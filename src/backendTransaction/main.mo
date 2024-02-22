import BasicBitcoin "canister:backend";

import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Cycles "mo:base/ExperimentalCycles";
import ExperimentalCycles "mo:base/ExperimentalCycles";
import Float "mo:base/Float";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Nat "mo:base/Nat";
import { compare } "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Order "mo:base/Order";
import Text "mo:base/Text";
import Time "mo:base/Time";
import { recurringTimer; setTimer } "mo:base/Timer";

import BitcoinApi "../backend/BitcoinApi";
import Types "../commons/Types";
import Entity "Entity";
import MyDateTime "MyDateTime";
import Transaction "Transaction";
import Transactions "Transactions";

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
    stable var reversedTransactionArray : [Transaction] = [];
    var transactionBuffer = Buffer.fromArray<Transaction>(transactionArray);

    stable var amountArrayASC : [TransactionType] = [];
    stable var amountArrayDESC : [TransactionType] = [];
    stable var iDArrayASC : [TransactionType] = [];
    stable var iDArrayDESC : [TransactionType] = [];
    stable var recipientArrayASC : [TransactionType] = [];
    stable var recipientArrayDESC : [TransactionType] = [];
    stable var senderArrayASC : [TransactionType] = [];
    stable var senderArrayDESC : [TransactionType] = [];

    let canisterBitcoinAddress = address;
    let intervalSecondsForTimer = 86400; // Set your desired interval here
    stable var processedBlocksArr : [BlockHeight] = [];
    var processedBlocksBuffer = Buffer.fromArray<BlockHeight>(processedBlocksArr);

    public func createTransaction(transactionID : Text, source : Text, amount : Types.Amount, receivers : [Types.Reciever], entityID : Nat, status : Types.Status, lastCanisterBalanceInSatoshi : Types.Satoshi, lastBlockInCanisterHeight : Nat32) : async Transaction {
        let dateTime = Time.now();
        let cycles2 = Cycles.add(200000000000);
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

    public func getCountOfAllTransactions() : async Nat {
        return transactionArray.size();
    };

    public func reverseTransactionArray() : async [Transaction] {
        if (transactionArray.size() != reversedTransactionArray.size()) {
            reversedTransactionArray := Array.reverse(transactionArray);
            return reversedTransactionArray;
        } else {
            return reversedTransactionArray;
        };
    };

    public func mapSortingArray(array : [TransactionType], sortField : Text, isAscending : Bool) : async [TransactionType] {
        if (array.size() != reversedTransactionArray.size()) {
            let nonNullable = await getTransactionTypeListFromNonNullable(reversedTransactionArray);
            switch (sortField, isAscending) {
                case ("ID", true) {
                    iDArrayASC := nonNullable;
                    return iDArrayASC;
                };
                case ("ID", false) {
                    iDArrayDESC := nonNullable;
                    return iDArrayDESC;
                };
                case ("Amount", true) {
                    amountArrayASC := nonNullable;
                    return amountArrayASC;
                };
                case ("Amount", false) {
                    amountArrayDESC := nonNullable;
                    return amountArrayDESC;
                };
                case ("Recipient", true) {
                    recipientArrayASC := nonNullable;
                    return recipientArrayASC;
                };
                case ("Recipient", false) {
                    recipientArrayDESC := nonNullable;
                    return recipientArrayDESC;
                };
                case ("Sender", true) {
                    senderArrayASC := nonNullable;
                    return senderArrayASC;
                };
                case ("Sender", false) {
                    senderArrayDESC := nonNullable;
                    return senderArrayDESC;
                };
                case (_, _) { return nonNullable };
            };
        } else {
            return array;
        };
    };

    public func updateSortingArray(array : [TransactionType], sortField : Text, isAscending : Bool) : async [TransactionType] {
        let transactionArrayCase : [TransactionType] = switch (sortField, isAscending) {
            case ("ID", true) {
                iDArrayASC := array;
                return iDArrayASC;
            };
            case ("ID", false) {
                iDArrayDESC := array;
                return iDArrayDESC;
            };
            case ("Amount", true) {
                amountArrayASC := array;
                return amountArrayASC;
            };
            case ("Amount", false) {
                amountArrayDESC := array;
                return amountArrayDESC;
            };
            case ("Recipient", true) {
                recipientArrayASC := array;
                return recipientArrayASC;
            };
            case ("Recipient", false) {
                recipientArrayDESC := array;
                return recipientArrayDESC;
            };
            case ("Sender", true) {
                senderArrayASC := array;
                return senderArrayASC;
            };
            case ("Sender", false) {
                senderArrayDESC := array;
                return senderArrayDESC;
            };
            case (_, _) {
                return await getTransactionTypeListFromNonNullable(reversedTransactionArray);
            };
        };
    };

    public func getAllTransactionsSubset(pageNumber : Nat, pageSize : Nat) : async [TransactionType] {
        let reversedTotalTransactions = await reverseTransactionArray();
        let totalTransactions = Array.size(reversedTotalTransactions);
        var startIndex = (pageNumber - 1) * pageSize;
        var endIndex = Nat.min(startIndex + pageSize, totalTransactions);
        if (startIndex >= totalTransactions) {
            let outOfBoundsArray = getTransactionTypeListFromNonNullable(reversedTotalTransactions);
            return await outOfBoundsArray;
        };

        let sortedReversedArray = Iter.toArray(Array.slice(reversedTotalTransactions, startIndex, endIndex));
        return await getTransactionTypeListFromNonNullable(sortedReversedArray);
    };

    public func getAllTransactionsSubsetArrayArgs(sortedSliced : [TransactionType], pageNumber : Nat, pageSize : Nat) : async [TransactionType] {
        let totalTransactions = Array.size(sortedSliced);
        var startIndex = (pageNumber - 1) * pageSize;
        var endIndex = Nat.min(startIndex + pageSize, totalTransactions);
        if (startIndex >= totalTransactions) {
            return sortedSliced;
        };

        let sortedReversedArray = Iter.toArray(Array.slice(sortedSliced, startIndex, endIndex));
        return sortedReversedArray;
    };

    public func getAllTransactionTypes(pageNumber : Nat, pageSize : Nat) : async [TransactionType] {
        let slicedTransactions = await getAllTransactionsSubset(pageNumber, pageSize);

        return slicedTransactions;
    };

    private func merge<T>(left : [T], right : [T], isAscending : Bool, compareFunc : (T, T) -> Bool) : [T] {
        var result = Buffer.Buffer<T>(0);
        var i = 0;
        var j = 0;

        while (i < left.size() and j < right.size()) {
            var shouldAppendLeft : Bool = false;

            if (isAscending) {
                shouldAppendLeft := compareFunc(left[i], right[j]);
            } else {
                shouldAppendLeft := compareFunc(right[j], left[i]);
            };

            if (shouldAppendLeft) {
                result.add(left[i]);
                i += 1;
            } else {
                result.add(right[j]);
                j += 1;
            };
        };

        while (i < left.size()) {
            result.add(left[i]);
            i += 1;
        };

        while (j < right.size()) {
            result.add(right[j]);
            j += 1;
        };

        let comparedArray = Buffer.toArray<T>(result);
        return comparedArray;
    };

    private func mergeSort<T>(array : [TransactionType], isAscending : Bool, compareFunc : (TransactionType, TransactionType) -> Bool) : async [TransactionType] {
        if (Array.size(array) <= 1) {
            return array;
        };

        let mid : Nat = Array.size(array) / 2;
        let left = await mergeSort(Iter.toArray(Array.slice(array, 0, mid)), isAscending, compareFunc);
        let right = await mergeSort(Iter.toArray(Array.slice(array, mid, Array.size(array))), isAscending, compareFunc);

        return merge(left, right, isAscending, compareFunc);
    };

    public func getSortedArray(sortField : Text, isAscending : Bool) : async [TransactionType] {
        let sortedArray : [TransactionType] = switch (sortField, isAscending) {
            case ("ID", true) { iDArrayASC };
            case ("ID", false) { iDArrayDESC };
            case ("Amount", true) { amountArrayASC };
            case ("Amount", false) { amountArrayDESC };
            case ("Recipient", true) { recipientArrayASC };
            case ("Recipient", false) { recipientArrayDESC };
            case ("Sender", true) { senderArrayASC };
            case ("Sender", false) { senderArrayDESC };
            case (_, _) {
                await getTransactionTypeListFromNonNullable(reversedTransactionArray);
            };
        };
        return sortedArray;
    };

    public func sortTransactionTypes(pageNumber : Nat, pageSize : Nat, sortField : Text, isAscending : Bool) : async [TransactionType] {
        let reversedTotalTransactions = await getTransactionTypeListFromNonNullable(await reverseTransactionArray());
        let caseArray = await getSortedArray(sortField, isAscending);

        if (reversedTotalTransactions.size() != caseArray.size()) {
            let sortedMappedCaseArray = await mapSortingArray(caseArray, sortField, isAscending);
            let compareFunc = func(t1 : TransactionType, t2 : TransactionType) : Bool {
                switch (sortField) {
                    case ("ID") {
                        return t1.transactionID < t2.transactionID;
                    };
                    case ("Recipient") {
                        return t1.transactionReceivers[0].benificiary.donation < t2.transactionReceivers[0].benificiary.donation;
                    };
                    case ("Sender") {
                        return t1.sourceBTCAddy < t2.sourceBTCAddy;
                    };
                    case ("Amount") {
                        return t1.transactionAmount.amountBTC > t2.transactionAmount.amountBTC;
                    };
                    case (_) { false };
                };
            };
            let sortedSlice = await mergeSort(sortedMappedCaseArray, isAscending, compareFunc);
            let replaceValues = await updateSortingArray(sortedSlice, sortField, isAscending);
            let slicedTransactions = await getAllTransactionsSubsetArrayArgs(replaceValues, pageNumber, pageSize);
            return slicedTransactions;
        } else {
            return await getAllTransactionsSubsetArrayArgs(caseArray, pageNumber, pageSize);
        };
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
        switch (transaction) {
            case (null) { return null };
            case (?transaction) {
                let transactionType = await getTransactionTypeFrom(transaction);
                return ?transactionType;
            };
        };

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

    public func getTransactionTypesByEntityId(id : Nat) : async ?[TransactionType] {
        let arr = await getTransactionsByEntityId(id);
        switch (arr) {
            case (null) { return null };
            case (?arr) {
                let typesArr = await getTransactionTypeListFrom(?arr);
                return typesArr;
            };
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

    public func getTransactionTypeByStatus(status : Types.Status) : async ?[TransactionType] {
        let arr = await getTransactionByStatus(status);
        let typesArr = await getTransactionTypeListFrom(?arr);
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

    public func getTransactionTypeListFromNonNullable(transactions : [Transaction]) : async [TransactionType] {
        let transactionTypeBuffer = Buffer.Buffer<TransactionType>(0);
        for (transaction in transactions.vals()) {
            transactionTypeBuffer.add(await getTransactionTypeFrom(transaction));
        };
        return Buffer.toArray(transactionTypeBuffer);
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

    public func createAndAddEntity(name : Text, category : Types.Category) : async () {
        var entity = await createEntity(name, category);
        await storeEntity(entity);
    };

    public func createEntity(name : Text, category : Types.Category) : async Entity {
        let cycles = Cycles.add(200000000000);
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
        let arr = await getAllEntities();
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

    public func getEntityTypeById(id : Nat) : async ?EntityType {
        let entity = await getEntityById(id);
        switch (entity) {
            case (null) { return null };
            case (?entity) {
                let entType = await getEntityTypeFrom(entity);
                return ?entType;
            };
        };
    };

    public func getEntityTypeFrom(entity : Entity) : async EntityType {
        return {
            id = await entity.getID();
            name = await entity.getName();
            category = await entity.getCategory();
        };
    };

    public func getEntityTypeListFrom(entities : ?[Entity]) : async ?[EntityType] {
        switch (entities) {
            case (null) { null };
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
        resetID();
    };

    // ignore recurringTimer(#seconds intervalSecondsForTimer, updateTransactionStatus);
};
