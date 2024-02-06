import Array "mo:base/Array";
import Nat "mo:base/Nat";
import Int "mo:base/Int";
import Float "mo:base/Float";
import Time "mo:base/Time";
import Nat32 "mo:base/Nat32";
import Types "../commons/Types";
import MyDateTime "MyDateTime";

actor class Transaction(id : Nat, source : Text, amount : Types.Amount, dateTime : MyDateTime.MyDateTime, receivers : [Types.Reciever], entityID : Nat, status : Types.Status, lastCanisterBalanceInSatoshi : Types.Satoshi, lastBlockInCanisterHeight : Nat32) {
    type MyDateTime = MyDateTime.MyDateTime;
    var transactionID : Nat = id;
    var sourceBTCAddy : Text = source;
    var transactionAmount : Types.Amount = amount;
    var transactionDateTime : MyDateTime = dateTime;
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

    public query func getDateTime() : async MyDateTime {
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

    public func setDateTime(newDateTime : MyDateTime) : async () {
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

    public func updateTransactionStatus(utxos : [Types.Utxo], canisterCurrentBalance : Types.Satoshi, timeOfCheck : Time.Time) : async () {
        var aDaySince = await transactionDateTime.didADayPassSince(timeOfCheck);
        var amountInSatoshi = transactionAmount.amountInSatoshi;
        // var lastHeight = lastCheckedHeight;
        if (canisterCurrentBalance > amountInSatoshi and not aDaySince) {
            label iterateUtxos for (utxo in utxos.vals()) {
                var currentHeight = utxo.height;
                if (utxo.value == amountInSatoshi and currentHeight >= lastBlockInCanisterHeight) {
                    await setStatus(#confirmed);
                    break iterateUtxos;
                };
            };
        } else {
            await setStatus(#rejected);
        };
    };
};