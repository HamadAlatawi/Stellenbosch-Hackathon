import TransactionTypes "../commons/TransactionTypes";
import Time "mo:base/Time";

actor class CommonTransaction() {
    public query func getTransactionId() : async Text {
        return "";
    };

    public query func getAmounts() : async [TransactionTypes.Amount] {
        return [];
    };

    public query func getReceivedTime() : async TransactionTypes.DateTime {
        return Time.now();
    };

    public query func getReceivers() : async [TransactionTypes.Reciever] {
        return [];
    };

    public query func getEntityId() : async Nat {
        return 0;
    };

    public query func getEntityName() : async Text {
        return "";
    };

    public query func getStatus() : async TransactionTypes.Status {
        return #pending;
    };

    public func confirmTransaction(timeOfCheck : TransactionTypes.DateTime) : async TransactionTypes.Status {
        return #pending;
    };

    // public func getTimeElapsed(baseTime : TransactionTypes.DateTime) : async Int {
    //     return 0;
    // };

    // public func didADayPassSince(baseTime : TransactionTypes.DateTime) : async Bool {
    //     return false;
    // };

    public func getTransactionDetails() : async Any {
        return "";
    };
}