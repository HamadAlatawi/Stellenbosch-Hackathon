import TransactionTypes "../commons/TransactionTypes";
import BitcoinTransaction "BitcoinTransaction";
import BitcoinApi "../backend/BitcoinApi";
import ProofOfConceptTransaction "ProofOfConceptTransaction";
import Error "mo:base/Error";

type BitcoinTransactionDetails = TransactionTypes.BitcoinTransactionDetails;
type Amount = TransactionTypes.Amount;
type DateTime = TransactionTypes.DateTime;
type Reciever = TransactionTypes.Reciever;
type Status = TransactionTypes.Status;
type TransactionType = TransactionTypes.TransactionType;
type BitcoinTransaction = BitcoinTransaction.BitcoinTransaction;
type ProofOfConceptTransaction = ProofOfConceptTransaction.ProofOfConceptTransaction;

actor class Transaction(txType : TransactionType, bitcoinTx : ?BitcoinTransaction, pocTx : ?ProofOfConceptTransaction) {
    let transactionType : TransactionType = txType;
    var bitcoinTransaction : ?BitcoinTransaction = bitcoinTx;
    var proofOfConceptTransaction : ?ProofOfConceptTransaction = pocTx;

    public query func getTransactionId() : async Text {
        if(await isBtcTransction()) {

        }
    };

    public query func getAmounts() : async [Amount] {
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

    public func getTransactionDetails() : async Any {
        return "";
    };

    //HELPER FUNCTIONS BTC
    private func isBtcTransction() : Bool {
        if (transactionType == #BTC) {
            return true;
        };
        return false;
    };

    private func getBtcTransaction() : async BitcoinTransaction {
        switch (?bitcoinTransaction) {
            case (null) { throw Error.reject("No Bitcoin transaction found!") };
            case (bitcoinTransaction) { return bitcoinTransaction };
        };
    };

    //HELPER FUNCTIONS POC
    private func isPocTransction() : async Bool {
        if (transactionType == #POC) {
            return true;
        };
        return false;
    };

    private func getPocTransaction() : async ProofOfConceptTransaction {
        switch (?proofOfConceptTransaction) {
            case (null) { throw Error.reject("No ProofOfConcept transaction found!") };
            case (proofOfConceptTransaction) { return proofOfConceptTransaction };
        };
    };
};
