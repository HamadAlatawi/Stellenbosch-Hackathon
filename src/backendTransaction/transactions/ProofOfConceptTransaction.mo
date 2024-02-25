import CommonTransaction "CommonTransaction";
import TransactionTypes "../../commons/TransactionTypes";

actor class ProofOfConceptTransaction(transactionDetails : TransactionTypes.POCTransactionDetails) : async CommonTransaction.CommonTransaction {
    type DateTime = TransactionTypes.DateTime;
    type Amount = TransactionTypes.Amount;
    type Reciever = TransactionTypes.Reciever;
    type Status = TransactionTypes.Status;

    let receivedTime : DateTime = transactionDetails.commonTransactionDetails.receivedTime;
    let transactionId : Text = transactionDetails.commonTransactionDetails.transactionId;
    let amounts : [Amount] = transactionDetails.commonTransactionDetails.amounts;
    let receivers : [Reciever] = transactionDetails.commonTransactionDetails.receivers;
    let receivingEntityId : Nat = transactionDetails.commonTransactionDetails.receivingEntityId;
    let receivingEntityName : Text = transactionDetails.commonTransactionDetails.receivingEntityName;
    var status : Status = transactionDetails.commonTransactionDetails.status;

    type CommonTransaction = CommonTransaction.CommonTransaction;
    public query func getTransactionId() : async Text {
        return transactionId;
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

    public query func getStatus() : async TransactionTypes.Status {
        return status;
    };

    public func confirmTransaction(timeOfCheck : TransactionTypes.DateTime) : async TransactionTypes.Status {
        status := #confirmed;
        return status;
    };

    public func getTransactionDetails() : async TransactionTypes.POCTransactionDetails {
        return {
            commonTransactionDetails = {
                amounts = amounts;
                receivers = receivers;
                receivingEntityId = receivingEntityId;
                receivingEntityName = receivingEntityName;
                status = status;
                transactionId = transactionId;
                receivedTime = receivedTime;
            };
        };
    };
};