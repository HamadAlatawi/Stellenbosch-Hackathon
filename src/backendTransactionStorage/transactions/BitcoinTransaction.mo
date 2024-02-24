import Int "mo:base/Int";
import TransactionTypes "../../commons/TransactionTypes";
import Types "../../commons/Types";
import CommonTransaction "CommonTransaction";

actor class BitcoinTransaction(transactionDetails : TransactionTypes.BitcoinTransactionDetails) : async CommonTransaction.CommonTransaction {
    type BitcoinTransactionDetails = TransactionTypes.BitcoinTransactionDetails;
    type Amount = TransactionTypes.Amount;
    type DateTime = TransactionTypes.DateTime;
    type Reciever = TransactionTypes.Reciever;
    type Status = TransactionTypes.Status;
    type BitcoinAddress = Types.BitcoinAddress;

    let receivedTime : DateTime = transactionDetails.commonTransactionDetails.receivedTime;
    let transactionId : Text = transactionDetails.commonTransactionDetails.transactionId;
    let sourceBtcAddress : BitcoinAddress = transactionDetails.sourceBtcAddress;
    let amounts : [Amount] = transactionDetails.commonTransactionDetails.amounts;
    let receivers : [Reciever] = transactionDetails.commonTransactionDetails.receivers;
    let receivingEntityId : Nat = transactionDetails.commonTransactionDetails.receivingEntityId;
    let receivingEntityName : Text = transactionDetails.commonTransactionDetails.receivingEntityName;
    var status : Status = transactionDetails.commonTransactionDetails.status;

    public query func getTransactionId() : async Text {
        return transactionId;
    };

    public query func getSourceAddress() : async Text {
        return sourceBtcAddress;
    };

    public query func getAmounts() : async [Amount] {
        return amounts;
    };

    public query func getReceivedTime() : async DateTime {
        return receivedTime;
    };

    public query func getReceivers() : async [Reciever] {
        return receivers;
    };

    public query func getEntityId() : async Nat {
        return receivingEntityId;
    };

    public query func getEntityName() : async Text {
        return receivingEntityName;
    };

    public query func getStatus() : async Status {
        return status;
    };

    public func confirmTransaction(timeOfCheck : DateTime) : async Status {
        let zero : Int = 0;
        let twoDays : Int = 2;
        let daysPassedSince = TransactionTypes.daysPassedSince(timeOfCheck, receivedTime);
        if (daysPassedSince != zero and daysPassedSince <= twoDays) {
            //TODO: confirm logic
            status := #confirmed;
        } else if (daysPassedSince > twoDays) {
            status := #rejected;
        };
        return status;
    };

    public func getTransactionDetails() : async BitcoinTransactionDetails {
        return {
            commonTransactionDetails = {
                transactionId = transactionId;
                amounts = amounts;
                receivers = receivers;
                receivingEntityId = receivingEntityId;
                receivingEntityName = receivingEntityName;
                status = status;
                receivedTime = receivedTime;
            };
            sourceBtcAddress = sourceBtcAddress;
        };
    };
};
