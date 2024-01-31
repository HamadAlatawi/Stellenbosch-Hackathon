import Array "mo:base/Array";
import Types "Types";

actor class Transaction (id:Nat, source:Text, amount: Types.Amount, dateTime:Text, receivers:[Types.Reciever], entityID:Nat){
    var transactionID: Nat = id;
    var sourceBTCAddy: Text = source;
    var transactionAmount: Types.Amount = amount;
    var transactionDateTime: Text = dateTime;
    var transactionReceivers: [Types.Reciever] = receivers;
    var transactionEntityID: Nat = entityID;

    public query func getID(): async Nat {
        return transactionID;
    };

    public query func getSource(): async Text {
        return sourceBTCAddy;
    };

    public query func getAmount(): async Types.Amount {
        return transactionAmount;
    };

    public query func getDateTime(): async Text {
        return transactionDateTime;
    };

    public query func getReceivers(): async [Types.Reciever] {
        return transactionReceivers;
    };

    public query func getEntityID(): async Nat {
        return transactionEntityID;
    };

    public func setSource(newSource: Text): async () {
        sourceBTCAddy := newSource;
    };

    public func setAmount(newAmount: Types.Amount): async () {
        transactionAmount := newAmount;
    };

    public func setDateTime(newDateTime: Text): async () {
        transactionDateTime := newDateTime;
    };

    public func setReceivers(newReceivers: [Types.Reciever]): async () {
        transactionReceivers := newReceivers;
    };

    public func setEntityID(newEntityID: Nat): async () {
        transactionEntityID := newEntityID;
    };
};
