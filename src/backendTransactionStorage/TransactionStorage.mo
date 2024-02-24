import TransactionTypes "../commons/TransactionTypes";
import SharedTypes "../commons/SharedTypes";
import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Error "mo:base/Error";
import Float "mo:base/Float";
import BitcoinTransaction "transactions/BitcoinTransaction";
import Types "../commons/Types";
import Transaction "transactions/Transaction";
import Cycles "mo:base/ExperimentalCycles";
import ExperimentalCycles "mo:base/ExperimentalCycles";
import Nat "mo:base/Nat";
import Time "mo:base/Time";
import Array "mo:base/Array";
import EntityTypes "../commons/EntityTypes";
import ProofOfConceptTransaction "transactions/ProofOfConceptTransaction";

actor class TransactionStorage() {
    //TYPES
    type TransactionType = SharedTypes.TransactionType;
    type BitcoinTransaction = BitcoinTransaction.BitcoinTransaction;
    type BitcoinTransactionDetails = TransactionTypes.BitcoinTransactionDetails;
    type CommonTransactionDetails = TransactionTypes.CommonTransactionDetails;
    type Amount = TransactionTypes.Amount;
    type Reciever = TransactionTypes.Reciever;
    type Status = TransactionTypes.Status;
    type Transaction = Transaction.Transaction;
    type TransactionTypeShared = TransactionTypes.TransactionTypeShared;
    type Entity = EntityTypes.Entity;
    type Category = EntityTypes.Category;
    type POCTransactionDetails = TransactionTypes.POCTransactionDetails;
    type ProofOfConceptTransaction = ProofOfConceptTransaction.ProofOfConceptTransaction;
    type Currency = TransactionTypes.Currency;

    //Transaction Storage
    stable var transactionArray : [Transaction] = [];
    var transactionBuffer = Buffer.fromArray<Transaction>(transactionArray);

    //Entities Storage
    stable var entityId = 1;
    stable var entityArray : [Entity] = [];
    var entityBuffer = Buffer.fromArray<Entity>(entityArray);

    public func storeBtcTransaction(transactionId : Text, sourceAddress : Types.BitcoinAddress, amounts : [Amount], receivers : [Reciever], receivingEntityId : Nat) : async BitcoinTransactionDetails {
        let entity = await getEntityById(receivingEntityId);
        let btcDetails : BitcoinTransactionDetails = {
            commonTransactionDetails = {
                amounts = amounts;
                receivers = normalizeReceivers(receivers);
                receivingEntityId = receivingEntityId;
                receivingEntityName = entity.name;
                status = #pending;
                transactionId = transactionId;
                receivedTime = Time.now();
            };
            sourceBtcAddress = sourceAddress;
        };
        let cycles1 = ExperimentalCycles.add(200000000000);
        let btcTransaction = await BitcoinTransaction.BitcoinTransaction(btcDetails);
        let cycles2 = ExperimentalCycles.add(200000000000);
        let transaction = await Transaction.Transaction(#BTC(btcTransaction));
        transactionBuffer.insert(0, transaction);
        transactionArray := Buffer.toArray<Transaction>(transactionBuffer);
        return await transaction.getBtcTransactionDetails();
    };

    public func storePocTransaction(transactionId : Text, amounts : [Amount], receivers : [Reciever], receivingEntityId : Nat) : async POCTransactionDetails {
        let entity = await getEntityById(receivingEntityId);
        let pocDetails : POCTransactionDetails = {
            commonTransactionDetails = {
                amounts = amounts;
                receivers = receivers;
                receivingEntityId = receivingEntityId;
                receivingEntityName = entity.name;
                status = #pending;
                transactionId = transactionId;
                receivedTime = Time.now();
            };
        };
        let cycles1 = ExperimentalCycles.add(200000000000);
        let pocTransaction = await ProofOfConceptTransaction.ProofOfConceptTransaction(pocDetails);
        let cycles2 = ExperimentalCycles.add(200000000000);
        let transaction = await Transaction.Transaction(#POC(pocTransaction));
        transactionBuffer.insert(0, transaction);
        transactionArray := Buffer.toArray<Transaction>(transactionBuffer);
        return await transaction.getPOCTransactionDetails();
    };

    public func getAllTransactions() : async [Transaction] {
        return transactionArray;
    };

    public func getAllTransactionsSharedType() : async [TransactionTypeShared] {
        let sharedTransactionsType = Buffer.Buffer<TransactionTypeShared>(0);
        for (transaction in transactionArray.vals()) {
            sharedTransactionsType.add(await transaction.getTransactionDetails());
        };
        return Buffer.toArray(sharedTransactionsType);
    };

    private func getTransactionById(id : Text) : async Transaction {
        for (transaction in transactionArray.vals()) {
            let transactionId = await transaction.getTransactionId();
            if (Text.compare(id, transactionId) == #equal) {
                switch (?transaction) {
                    case (null) {};
                    case (?transaction) { return transaction };
                };
            };
        };
        throw Error.reject("Transaction with Id=" # id # "does not exist");
    };

    public func getTransactionByIdSharedType(id : Text) : async TransactionTypeShared {
        let transaction = await getTransactionById(id);
        await transaction.getTransactionDetails();
    };

    public func getTransactionsByEntityId(entityId : Nat) : async [TransactionTypeShared] {
        let transactionOfEntity = Buffer.Buffer<TransactionTypeShared>(0);
        for (transaction in transactionArray.vals()) {
            let transactionEntityId = await transaction.getEntityId();
            if (transactionEntityId == entityId) {
                transactionOfEntity.add(await transaction.getTransactionDetails());
            };
        };
        if (transactionOfEntity.size() == 0) { return [] };
        let transactionOfEntityArray = Buffer.toArray<TransactionTypeShared>(transactionOfEntity);
        return transactionOfEntityArray;
    };

    public func getAccumulatedByEntity(entityId : Nat) : async [Amount] {
        let transactions = await getTransactionsByEntityId(entityId);
        if (transactions.size() == 0) {
            return [];
        };

        var sumBtc : Float = 0.0;
        var sumPOC : Float = 0.0;
        var sumSatoshi : Float = 0.0;

        for (transaction in transactions.vals()) {
            switch (transaction) {
                case (#BTC(transaction)) {
                    var amountBtc = TransactionTypes.findAmountForCurrency(transaction.commonTransactionDetails.amounts, #bitcoin);
                    var amountSatoshi = TransactionTypes.findAmountForCurrency(transaction.commonTransactionDetails.amounts, #satoshi);
                    sumBtc += amountBtc;
                    sumSatoshi += amountSatoshi;
                };
                case (#POC(transaction)) {
                    var amountPOC = TransactionTypes.findAmountForCurrency(transaction.commonTransactionDetails.amounts, #proofOfConcept);
                    sumPOC += amountPOC;
                };
            };
        };

        return [{ amount = sumBtc; currency = #bitcoin }, { amount = sumSatoshi; currency = #satoshi }, { amount = sumPOC; currency = #proofOfConcept }];
    };

    public func getAccumulatedByBeneficiary(benificiary : Text) : async [Amount] {
        let normalizedBeneficiary = Text.toLowercase(benificiary);
        var sumBtc : Float = 0.0;
        var sumPOC : Float = 0.0;
        var sumSatoshi : Float = 0.0;

        for (transaction in transactionArray.vals()) {
            let receivers = await transaction.getReceivers();
            for (receiver in receivers.vals()) {
                if (receiver.benificiary == normalizedBeneficiary) {
                    let amounts = receiver.amounts;
                    var amountBtc = TransactionTypes.findAmountForCurrency(amounts, #bitcoin);
                    var amountSatoshi = TransactionTypes.findAmountForCurrency(amounts, #satoshi);
                    var amountPOC = TransactionTypes.findAmountForCurrency(amounts, #proofOfConcept);
                    sumBtc += amountBtc;
                    sumSatoshi += amountSatoshi;
                    sumPOC += amountPOC;
                };
            };

        };
        return [{ amount = sumBtc; currency = #bitcoin }, { amount = sumSatoshi; currency = #satoshi }, { amount = sumPOC; currency = #proofOfConcept }];
    };

    private func getTransactionByStatus(status : Types.Status) : async [Transaction] {
        let buffer = Buffer.Buffer<Transaction>(0);
        for (transaction in transactionArray.vals()) {
            let transactionStatus = await transaction.getStatus();
            if (transactionStatus == status) {
                buffer.add(transaction);
            };
        };
        return Buffer.toArray(buffer);
    };

    public func getSharedTransactionTypeByStatus(status : Types.Status) : async [TransactionTypeShared] {
        let transactionsByStatus = await getTransactionByStatus(status);
        await getTransactionTypeListFrom(transactionsByStatus);
    };

    public func getTransactionByCurrency(currency : Currency) : async [TransactionTypeShared] {
        let buffer = Buffer.Buffer<TransactionTypeShared>(0);
        let transactions = await getAllTransactionsSharedType();
        for (transaction in transactions.vals()) {
            switch (transaction) {
                case (#BTC(transaction)) {
                    if (currency == #bitcoin or currency == #satoshi) {
                        buffer.add(#BTC(transaction));
                    };
                };
                case (#POC(transaction)) {
                    if (currency == #proofOfConcept) {
                        buffer.add(#POC(transaction));
                    };
                };
            };
        };
        return Buffer.toArray(buffer);
    };

    private func getTransactionTypeListFrom(transactions : [Transaction]) : async [TransactionTypeShared] {
        var sharedTypeTransactions = Buffer.Buffer<TransactionTypeShared>(transactions.size());
        for (transaction in transactions.vals()) {
            sharedTypeTransactions.add(await transaction.getTransactionDetails());
        };
        return Buffer.toArray(sharedTypeTransactions);
    };

    public func clearTransactions() {
        transactionArray := [];
        transactionBuffer.clear();
    };

    public func confirmTransactions() : async () {
        var currentTime = Time.now();
        var pendingTransactions = await getTransactionByStatus(#pending);
        for (transaction in pendingTransactions.vals()) {
            ignore await transaction.confirmTransaction(currentTime);
        };
    };

    // Entities Code
    public func createAndAddEntity(name : Text, category : Category) : async Entity {
        let entity : Entity = {
            id = entityId;
            name = name;
            category = category;
        };
        incrementEntityId();
        entityBuffer.add(entity);
        entityArray := Buffer.toArray<Entity>(entityBuffer);
        return entity;
    };

    public query func getAllEntities() : async [Entity] {
        return entityArray;
    };

    public func getEntityById(id : Nat) : async Entity {
        for (entity in entityArray.vals()) {
            if (entity.id == id) {
                return entity;
            };
        };
        throw Error.reject("Entity with Id=" # Nat.toText(id) # " is not found!");
    };

    public func clearEntities() {
        entityArray := [];
        entityBuffer.clear();
        entityId := 0;
    };

    private func incrementEntityId() : () {
        entityId += 1;
    };

    private func normalizeReceivers(receivers : [Reciever]) : [Reciever] {
        Array.map<Reciever, Reciever>(
            receivers,
            func receiver = {
                amounts = receiver.amounts;
                percentage = receiver.percentage;
                benificiary = Text.toLowercase(receiver.benificiary);
            },
        );
    };
};
