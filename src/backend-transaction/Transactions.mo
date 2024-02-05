import Transaction "Transaction";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import Float "mo:base/Float";
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

    public func getTransactionByEntityId(entityId : Nat) : async ?[Transaction] {
        let transactionArr = await getAllTransactions();
        let transactionOfEntity = Buffer.Buffer<Transaction>(0);
        for (transaction in transactionArr.vals()) {
            let transactionEntityId = await transaction.getEntityID();
            if (transactionEntityId == entityId) {
                transactionOfEntity.add(transaction);
            };
        };
        if (transactionOfEntity.size()==0){return null};
        let transactionOfEntityArray = Buffer.toArray<Transaction>(transactionOfEntity);
        return ?transactionOfEntityArray;
    };

    public func getAccumulatedByEntity(entityId:Nat): async Float {
        let transactions=
        switch (await getTransactionByEntityId(entityId)){
            case (null) return 0.0;
            case (?y) y;
        };
        var sum: Float = 0.0;
        for (transaction in transactions.vals()){
            let amount = await transaction.getAmount();
            sum+= amount.amountBTC;
        };
        return sum;
    };
    
    public func getAccumulatedByBeneficiary(benificiary: Types.Benificiary): async Float {
        let transactionArr = await getAllTransactions();
        var sum: Float= 0.0;
        for (transaction in transactionArr.vals()) {
            let receivers = await transaction.getReceivers();
            for (receiver in receivers.vals()){
                if (receiver.benificiary==benificiary){
                    sum += receiver.amount.amountBTC;
                };
            };
            };
        return sum;
    };

};
