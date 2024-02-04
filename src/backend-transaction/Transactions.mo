import Transaction "Transaction";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import Types "../commons/Types";
import MyDateTime "MyDateTime";

actor class Transactions() {
    type Transaction = Transaction.Transaction;
    stable var transactionArray : [Transaction] = [];
    var transactionBuffer = Buffer.fromArray<Transaction>(transactionArray);
    stable var transactionID = 0;

    public func createTransaction(source : Text, amount : Types.Amount, receivers : [Types.Reciever], entityID : Nat, status : Types.Status, lastCanisterBalanceInSatoshi : Types.Satoshi, lastBlockInCanisterHeight : Nat32) : async Transaction {
        let dateTime = await MyDateTime.MyDateTime();
        let trans = await Transaction.Transaction(transactionID, source, amount, dateTime, receivers, entityID, status, lastCanisterBalanceInSatoshi, lastBlockInCanisterHeight);
        return trans;
    };

    public func incrementID() : () {
        transactionID += 1;
    };

    public query func getID() : async Nat {
        return transactionID;
    };

    public func resetID() : () {
        transactionID := 0;
    };

    public func storeTransaction(transaction : Transaction) : async () {
        transactionBuffer.add(transaction);
        incrementID();
        transactionArray := Buffer.toArray<Transaction>(transactionBuffer);
    };

    public query func getAllTransactions() : async [Transaction] {
        return transactionArray;
    };

    public func getTransactionById(id : Nat) : async ?Transaction {
        let transactionArr = await getAllTransactions();
        for (transaction in transactionArr.vals()) {
            let transactionId = await transaction.getID();
            if (transactionId == id) {
                switch (?transaction) {
                    case (null) {};
                    case (transaction) { return transaction };
                };
            };
        };
        return null;
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

    // public func getTransactionByEntityId(entityId : Nat) : async ?[Transaction] {
    //     let transactionArr = await getAllTransactions();
    //     let transactionOfEntity : Buffer.Buffer<Transaction>(0);
    //     for (transaction in transactionArr.vals()) {
    //         let transactionEntityId = await transaction.getEntityID();
    //         if (transactionEntityId == entityId) {
    //             transactionOfEntity.add(transaction);
    //         };
    //     };
    //     let transactionOfEntityArray = Buffer.toArray<Transaction>(transactionOfEntity);
    //     return transactionOfEntityArray;
    //     return null;
    // };

    // public func getAccumulatedByEntityId(entityId: Nat): async Float {
    //     let transactionArr = await getAllTransactions();
    //     let sum: Float= 0.0;
    //     for (transaction in transactionArr.vals()) {
    //         let transactionEntityId = await transaction.getEntityID();
    //         if (transactionEntityId == entityId) {
    //                let addition = await transaction.getAmount();
    //                 sum+=addition;
    //             };
    //         };
    //     let transactionOfEntityArray=Buffer.toArray<Transaction>(transactionOfEntity);
    //     return transactionOfEntityArray;
    //     return null;
    // };

    // public func getAccumulatedForBeneficiary(beneficiary:Beneficiary): Nat{
    //     let transactionArr = await getAllTransactions();
    //     for (transaction in transactionArr.vals()) {
    //         let transactionReceivers = (await transaction.getReceivers()).vals();
    //         for (reciever in transactionReceivers){
    //         if (transactionId == id) {
    //             switch (?transaction) {
    //                 case (null) { };
    //                 case (transaction) { return transaction; };
    //             }
    //         }
    //         }
    //     };
    // }

};
