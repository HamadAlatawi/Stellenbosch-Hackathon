import TransactionTypes "../commons/TransactionTypes";
import SharedTypes "../commons/SharedTypes";
import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Error "mo:base/Error";
import Float "mo:base/Float";
import BitcoinTransaction "../transactions/BitcoinTransaction";
import Types "../commons/Types";
import Transaction "../transactions/Transaction";
import Transactions "../backendTransaction/Transactions";
import Cycles "mo:base/ExperimentalCycles";

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

actor class TransactionStorage() {
    stable var transactionArray : [Transaction] = [];
    var transactionBuffer = Buffer.fromArray<Transaction>(transactionArray);

    public func storeBtcTransaction(transactionId : Text, sourceAddress : Types.BitcoinAddress, amounts : [Amount], receivers : [Reciever], receivingEntityId : Nat) : async BitcoinTransactionDetails {
        let btcDetails : BitcoinTransactionDetails = {
            commonTransactionDetails = {
                amounts = amounts;
                receivers = receivers;
                receivingEntityId = receivingEntityId;
                //TODO: Get Entity Name from Entity Storage Canister
                receivingEntityName = "";
                status = #pending;
                transactionId = transactionId;
            };
            sourceBtcAddress = sourceAddress;
        };
        let cycles2 = Cycles.add(200000000000);
        let t = await BitcoinTransaction.BitcoinTransaction(btcDetails);
        let btcTransaction = await Transaction.Transaction(#BTC(t));
        transactionBuffer.insert(0, btcTransaction);
        transactionArray := Buffer.toArray<Transaction>(transactionBuffer);
        return await btcTransaction.getBtcTransactionDetails();
    };

    public query func getAllTransactions() : async [Transaction] {
        return transactionArray;
    };

    public func getTransactionById(id : Text) : async Transaction {
        let transactionArr = await getAllTransactions();
        for (transaction in transactionArr.vals()) {
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
        let transactionArr = await getAllTransactions();
        let transactionOfEntity = Buffer.Buffer<TransactionTypeShared>(0);
        for (transaction in transactionArr.vals()) {
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
        var sumBtc : Float = 0.0;
        var sumPOC : Float = 0.0;
        var sumSatoshi : Float = 0.0;

        for (transaction in transactionArray.vals()) {
            let receivers = await transaction.getReceivers();
            let amounts = await transaction.getAmounts();
            for (receiver in receivers.vals()) {
                if (receiver.benificiary == benificiary) {
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

    public func getTransactionByStatus(status : Types.Status) : async [Transaction] {
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

    public func getTransactionTypeListFrom(transactions : [Transaction]) : async [TransactionTypeShared] {
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
};
