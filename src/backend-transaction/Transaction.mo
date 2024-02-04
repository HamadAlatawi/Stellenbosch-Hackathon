import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Float "mo:base/Float";
import Types "Types";

actor class Transaction(id : Nat, source : Text, amount : Types.Amount, dateTime : Types.MyDateTime, receivers : [Types.Reciever], entityID : Nat, status : Types.Status, lastCanisterBalanceInSatoshi : Types.Satoshi, lastBlockInCanisterHeight : Nat32) {
    var transactionID : Nat = id;
    var sourceBTCAddy : Text = source;
    var transactionAmount : Types.Amount = amount;
    var transactionDateTime : Types.MyDateTime = dateTime;
    var transactionReceivers : [Types.Reciever] = receivers;
    var transactionEntityID : Nat = entityID;
    var transactionStatus : Types.Status = status;

    public query func getID() : async Nat {
        return transactionID;
    };

    public query func getSource() : async Text {
        return sourceBTCAddy;
    };

    public query func getAmount() : async Types.Amount {
        return transactionAmount;
    };

    public query func getDateTime() : async Types.MyDateTime {
        return transactionDateTime;
    };

    public query func getReceivers() : async [Types.Reciever] {
        return transactionReceivers;
    };

    public query func getEntityID() : async Nat {
        return transactionEntityID;
    };

    public query func getStatus() : async Types.Status {
        return transactionStatus;
    };

    public func setSource(newSource : Text) : async () {
        sourceBTCAddy := newSource;
    };

    public func setAmount(newAmount : Types.Amount) : async () {
        transactionAmount := newAmount;
    };

    public func setDateTime(newDateTime : Types.MyDateTime) : async () {
        transactionDateTime := newDateTime;
    };

    public func setReceivers(newReceivers : [Types.Reciever]) : async () {
        transactionReceivers := newReceivers;
    };

    public func setEntityID(newEntityID : Nat) : async () {
        transactionEntityID := newEntityID;
    };

    public func setStatus(status : Types.Status) : async () {
        transactionStatus := status;
    };
};
