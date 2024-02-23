import Time "mo:base/Time";
import CommonTransaction "CommonTransaction";
import TransactionTypes "../../commons/TransactionTypes";

actor class ProofOfConceptTransaction() : async CommonTransaction.CommonTransaction {
    type CommonTransaction = CommonTransaction.CommonTransaction;
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

    public func getTransactionDetails() : async TransactionTypes.POCTransactionDetails {
        return {
            commonTransactionDetails = {
                amounts = await getAmounts();
                receivers = await getReceivers();
                receivingEntityId = await getEntityId();
                receivingEntityName = await getEntityName();
                status = await getStatus();
                transactionId = await getTransactionId();
            };
        };
    };
};
