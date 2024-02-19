import Array "mo:base/Array";
import Float "mo:base/Float";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Time "mo:base/Time";

import Types "../commons/Types";

actor class Transaction(id : Text, source : Text, amount : Types.Amount, dateTime : Types.DateTime, receivers : [Types.Reciever], entityID : Nat, status : Types.Status, lastCanisterBalanceInSatoshi : Types.Satoshi, lastBlockInCanisterHeight : Nat32) {
    type DateTime = Types.DateTime;
    type Utxo = Types.Utxo;
    let hourInNanoSecounds : Int = 86400000000000;
    var transactionID : Text = id;
    var sourceBTCAddy : Text = source;
    var transactionAmount : Types.Amount = amount;
    var transactionDateTime : DateTime = dateTime;
    var transactionReceivers : [Types.Reciever] = receivers;
    var transactionEntityID : Nat = entityID;
    var transactionStatus : Types.Status = status;
    var transactionLastCanisterBalanceInSatoshi : Types.Satoshi = lastCanisterBalanceInSatoshi;
    var transactionLastBlockInCanisterHeight : Nat32 = lastBlockInCanisterHeight;

    public query func getID() : async Text {
        return transactionID;
    };

    public query func getSourceAddress() : async Text {
        return sourceBTCAddy;
    };

    public query func getAmount() : async Types.Amount {
        return transactionAmount;
    };

    public query func getDateTime() : async DateTime {
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

    public query func getLastCanisterBalanceInSatoshi() : async Types.Satoshi {
    return transactionLastCanisterBalanceInSatoshi;
    };

    public query func getLastBlockInCanisterHeight() : async Nat32 {
    return transactionLastBlockInCanisterHeight;
    };

    public func getTimeElapsed(baseTime : Time.Time) : async Int {
        return baseTime - transactionDateTime;
    };

    public func setSource(newSource : Text) : async () {
        sourceBTCAddy := newSource;
    };

    public func setAmount(newAmount : Types.Amount) : async () {
        transactionAmount := newAmount;
    };

    public func setDateTime(newDateTime : DateTime) : async () {
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

    public func updateTransactionStatus(utxosHeight : Nat32, utxosValue : Types.Satoshi, canisterCurrentBalance : Types.Satoshi, timeOfCheck : Time.Time) : async Types.Status {
        var aDaySince = await didADayPassSince(timeOfCheck);
        var amountInSatoshi = transactionAmount.amountInSatoshi;
        if (canisterCurrentBalance > amountInSatoshi and not aDaySince) {
            var currentHeight = utxosHeight;
            if (utxosValue == amountInSatoshi and currentHeight >= lastBlockInCanisterHeight) {
                await setStatus(#confirmed);
                return #confirmed;
            };
            return #pending;
        } else {
            await setStatus(#rejected);
            return #rejected;
        };
    };

    public func didADayPassSince(baseTime : Time.Time) : async Bool {
        var difference = await getTimeElapsed(baseTime);
        difference >= hourInNanoSecounds;
    };

    public func setLastCanisterBalanceInSatoshi(newBalance : Types.Satoshi) : async () {
    transactionLastCanisterBalanceInSatoshi := newBalance;
    };

    public func setLastBlockInCanisterHeight(newHeight : Nat32) : async () {
        transactionLastBlockInCanisterHeight := newHeight;
    };
};