import Transaction "Transaction";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import Types "Types";

actor Transactions {
    type Transaction = Transaction.Transaction;
    stable var transactionArray: [Transaction] = [];
    var transactionBuffer = Buffer.fromArray<Transaction>(transactionArray);
    stable var transactionID = 0;

    public func createTransaction(source: Text, amount: Types.Amount, dateTime: Text, receivers: [Text], entityID: Nat): async Transaction {
        let trans = await Transaction.Transaction(transactionID, source, amount, dateTime, receivers, entityID);
        incrementID();
        return trans;
    };

    public func incrementID(): () {
        transactionID += 1;
    };

    public query func getID(): async Nat {
        return transactionID;
    };

    public func resetID(): () {
        transactionID := 0;
    };

    public func storeTransaction(transaction: Transaction): async () {
        transactionBuffer.add(transaction);
        transactionArray := Buffer.toArray<Transaction>(transactionBuffer);
    };

    public query func getAllTransactions(): async [Transaction] {
        return transactionArray;
    };

    public func getTransactionById(id: Nat): async ?Transaction {
        let transactionArr = await getAllTransactions();
        for (transaction in transactionArr.vals()) {
            let transactionId = await transaction.getID();
            if (transactionId == id) {
                switch (?transaction) {
                    case (null) { };
                    case (transaction) { return transaction; };
                }
            }
        };
        return null;
    };
};
