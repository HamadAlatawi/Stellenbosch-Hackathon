import BasicBitcoin "canister:backend";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Float "mo:base/Float";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Time "mo:base/Time";
import { recurringTimer; setTimer } "mo:base/Timer";
import Text "mo:base/Text";
import BitcoinApi "../backend/BitcoinApi";
import Types "../commons/Types";
import MyDateTime "MyDateTime";
import Transaction "Transaction";
import Transactions "Transactions";
import Cycles "mo:base/ExperimentalCycles";
import ExperimentalCycles "mo:base/ExperimentalCycles";
import Entity "Entity";

actor class TransactionsMain(address : Types.BitcoinAddress) {
    type BlockHeight = Types.BlockHeight;
    type Transaction = Transaction.Transaction;
    type Utxo = Types.Utxo;
    type Block = Types.Block;
    type TransactionType = Types.TransactionType;
    type Entity = Entity.Entity;
    type EntityType = Types.EntityType;
    stable var entityID = 0;
    stable var entityArray : [Entity] = [];
    var entityBuffer = Buffer.fromArray<Entity>(entityArray);

    stable var transactionArray : [Transaction] = [];
    var transactionBuffer = Buffer.fromArray<Transaction>(transactionArray);

    let canisterBitcoinAddress = address;
    let intervalSecondsForTimer = 86400; // Set your desired interval here
    stable var processedBlocksArr : [BlockHeight] = [];
    var processedBlocksBuffer = Buffer.fromArray<BlockHeight>(processedBlocksArr);
    
    

    public func createTransaction(transactionID : Text, source : Text, amount : Types.Amount, receivers : [Types.Reciever], entityID : Nat, status : Types.Status, lastCanisterBalanceInSatoshi : Types.Satoshi, lastBlockInCanisterHeight : Nat32) : async Transaction {
        let dateTime = Time.now();
        let cycles2 = Cycles.add(14692307692);
        let trans = await Transaction.Transaction(transactionID, source, amount, dateTime, receivers, entityID, status, lastCanisterBalanceInSatoshi, lastBlockInCanisterHeight);
        return trans;
    };

    public func storeTransaction(transaction : Transaction) : async () {
        transactionBuffer.add(transaction);
        transactionArray := Buffer.toArray<Transaction>(transactionBuffer);
    };

    public query func getAllTransactions() : async [Transaction] {
        return transactionArray;
    };

    public func getAllTransactionTypes() : async ?[TransactionType] {
        var transactions = await getAllTransactions();
        return await getTransactionTypeListFrom(?transactions);
    };

    public func getTransactionById(id : Text) : async ?Transaction {
        let transactionArr = await getAllTransactions();
        for (transaction in transactionArr.vals()) {
            let transactionId = await transaction.getID();
            if (Text.compare(id, transactionId) == #equal) {
                switch (?transaction) {
                    case (null) {};
                    case (transaction) { return transaction };
                };
            };
        };
        return null;
    };



    public func getTransactionTypeById(id : Text) : async ?TransactionType {
        let transaction = await getTransactionById(id);
        switch(transaction){
            case (null){return null;};
            case (?transaction){
                let transactionType= await getTransactionTypeFrom(transaction);
                return ?transactionType;}
        }
        
    };

    public func getTransactionsByEntityId(entityId : Nat) : async ?[Transaction] {
        let transactionArr = await getAllTransactions();
        let transactionOfEntity = Buffer.Buffer<Transaction>(0);
        for (transaction in transactionArr.vals()) {
            let transactionEntityId = await transaction.getEntityID();
            if (transactionEntityId == entityId) {
                transactionOfEntity.add(transaction);
            };
        };
        if (transactionOfEntity.size() == 0) { return null };
        let transactionOfEntityArray = Buffer.toArray<Transaction>(transactionOfEntity);
        return ?transactionOfEntityArray;
    };

    public func getTransactionTypesByEntityId(id:Nat): async ?[TransactionType]{
        let arr= await getTransactionsByEntityId(id);
        switch(arr) {
            case(null) {return null;};
            case(?arr) {let typesArr=await getTransactionTypeListFrom(?arr); return typesArr; };
        };
    };

    public func getAccumulatedByEntity(entityId : Nat) : async Float {
        let transactions = switch (await getTransactionsByEntityId(entityId)) {
            case (null) return 0.0;
            case (?y) y;
        };
        var sum : Float = 0.0;
        for (transaction in transactions.vals()) {
            let amount = await transaction.getAmount();
            sum += amount.amountBTC;
        };
        return sum;
    };

    public func getAccumulatedByBeneficiary(benificiary : Types.Beneficiary) : async Float {
        let transactionArr = await getAllTransactions();
        var sum : Float = 0.0;
        for (transaction in transactionArr.vals()) {
            let receivers = await transaction.getReceivers();
            for (receiver in receivers.vals()) {
                if (receiver.benificiary == benificiary) {
                    sum += receiver.amount.amountBTC;
                };
            };
        };
        return sum;
    };

    public func createAndAddTransaction(transactionID : Text, sourceAddress : Types.BitcoinAddress, amount : Types.Amount, receivers : [Types.Reciever], entityID : Nat) : async () {
        var lastBalance = await BasicBitcoin.get_balance(canisterBitcoinAddress);
        var lastBlockHeight = await BasicBitcoin.get_last_utxo_block_height(canisterBitcoinAddress);
        let status : Types.Status = #pending;
        var transaction = await createTransaction(transactionID, sourceAddress, amount, receivers, entityID, status, lastBalance, lastBlockHeight);
        await storeTransaction(transaction);
    };

    public func getTransactionByStatus(status : Types.Status) : async [Transaction] {
        let buffer = Buffer.Buffer<Transaction>(transactionArray.size());
        for (transaction in transactionArray.vals()) {
            let transactionStatus = await transaction.getStatus();
            if (transactionStatus == status) {
                buffer.add(transaction);
            };
        };
        return Buffer.toArray(buffer);
    };

    public func getTransactionTypeByStatus (status: Types.Status): async ?[TransactionType]{
        let arr=await getTransactionByStatus(status);
         let typesArr=await getTransactionTypeListFrom(?arr); 
         return typesArr; 
    };

    public func updateTransactionStatus() : async () {
        var utxoResponse = await BasicBitcoin.get_blocks(canisterBitcoinAddress);
        var unprocessedUtxos = await getUnprocessed(utxoResponse);
        var currentBalance = await BasicBitcoin.get_balance(canisterBitcoinAddress);
        var currentTime = Time.now();
        var pendingTransactions = await getTransactionByStatus(#pending);
        for (transaction in pendingTransactions.vals()) {
            label processUtxos for (utxo in unprocessedUtxos.vals()) {
                let status = await transaction.updateTransactionStatus(utxo.height, utxo.value, currentBalance, currentTime);
                switch status {
                    case (#confirmed) {
                        await updateProcessedBlocks(utxo.height);
                        break processUtxos;
                    };
                    case (#rejected) {
                        break processUtxos;
                    };
                    case (#pending) continue processUtxos;
                };
            };
        };
    };

    public func updateProcessedBlocks(height : BlockHeight) : async () {
        processedBlocksBuffer.add(height);
        processedBlocksArr := Buffer.toArray(processedBlocksBuffer);
    };

    public func getAllprocessedBlocks(height : BlockHeight) : async [BlockHeight] {
        processedBlocksArr;
    };

    public func getUnprocessed(utxos : [Block]) : async [Block] {
        var utxoBuf = Buffer.Buffer<Block>(utxos.size());
        for (utxo in utxos.vals()) {
            var height = utxo.height;
            let found = await isProcessed(height);
            if (not found) {
                utxoBuf.add(utxo);
            };
        };
        Buffer.toArray(utxoBuf);
    };

    public func isProcessed(x : BlockHeight) : async Bool {
        for (block in processedBlocksArr.vals()) {
            if (block == x) {
                return true;
            };
        };
        return false;
    };

    public func getTransactionTypeFrom(transaction : Transaction) : async TransactionType {
        return {
            transactionID = await transaction.getID();
            sourceBTCAddy = await transaction.getSourceAddress();
            transactionAmount = await transaction.getAmount();
            transactionDateTime = await transaction.getDateTime();
            transactionReceivers = await transaction.getReceivers();
            transactionEntityID = await transaction.getEntityID();
            transactionStatus = await transaction.getStatus();
        };
    };

    public func getTransactionTypeListFrom(transactions : ?[Transaction]) : async ?[TransactionType] {
        switch (transactions) {
            case (null) { null };
            case (?transactions) {
                let transactionTypeBuffer = Buffer.Buffer<TransactionType>(0);
                for (transaction in transactions.vals()) {
                    transactionTypeBuffer.add(await getTransactionTypeFrom(transaction));
                };
                return ?Buffer.toArray(transactionTypeBuffer);
            };
        };
    };

    public func clearTransactions() {
        transactionArray := [];
        transactionBuffer.clear();
    };

    public func createAndAddEntity(name : Text, category : Types.Category): async () {
        var entity = await createEntity (name, category);
        await storeEntity(entity); 
    };

    public func createEntity(name : Text, category : Types.Category) : async Entity {
        let cycles = Cycles.add(14692307692);
        let ent = await Entity.Entity(entityID, name, category);
        incrementID();
        return ent;
    };

    public func incrementID() : () {
        entityID += 1;
    };

    public query func getID() : async Nat {
        return entityID;
    };

    public func resetID() : () {
        entityID := 0;
    };

    public func storeEntity(entity : Entity) : async () {
        entityBuffer.add(entity);
        entityArray := Buffer.toArray<Entity>(entityBuffer);
    };

    public query func getAllEntities() : async [Entity] {
        return entityArray;
    };

    public func getAllEntitiesTypes() : async ?[EntityType] {
        let arr=await getAllEntities();
        return await getEntityTypeListFrom(?arr);
    };

    public func getEntityById(id : Nat) : async ?Entity {
        let entityArr = await getAllEntities();
        for (entity in entityArr.vals()) {
            let entityId = await entity.getID();
            if (entityId == id) {
                switch (?entity) {
                    case (null) {};
                    case (entity) { return entity };
                };
            };
        };
        return null;
    };

    public func getEntityTypeById(id : Nat): async ?EntityType {
        let entity = await getEntityById(id);
        switch (entity) {
                    case (null) {return null;};
                    case (?entity) { let entType= await getEntityTypeFrom(entity);
                                    return ?entType;};
    }; 
    };

    public func getEntityTypeFrom(entity: Entity): async EntityType {
        return{
            id= await entity.getID();
            name= await entity.getName();
            category=await entity.getCategory();
        };
    };

    public func getEntityTypeListFrom(entities: ?[Entity]) : async ?[EntityType] {
        switch (entities) {
            case (null) {null};
            case (?entities) {
                let entityTypeBuffer = Buffer.Buffer<EntityType>(0);
                for (entity in entities.vals()) {
                    entityTypeBuffer.add(await getEntityTypeFrom(entity));
                };
                return ?Buffer.toArray(entityTypeBuffer);
            };
        };
    };
    public func clearEntities() {
        entityArray := [];
        entityBuffer.clear();
    }; 
    
    // ignore recurringTimer(#seconds intervalSecondsForTimer, updateTransactionStatus);
};