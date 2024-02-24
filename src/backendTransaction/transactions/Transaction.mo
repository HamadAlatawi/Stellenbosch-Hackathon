import BitcoinTransaction "BitcoinTransaction";
import ProofOfConceptTransaction "ProofOfConceptTransaction";
import Error "mo:base/Error";
import Text "mo:base/Text";
import TransactionTypes "../../commons/TransactionTypes";
import Types "../../commons/Types";
import SharedTypes "../../commons/SharedTypes";

actor class Transaction(transaction : SharedTypes.TransactionType) {
    type BitcoinTransactionDetails = TransactionTypes.BitcoinTransactionDetails;
    type Amount = TransactionTypes.Amount;
    type DateTime = TransactionTypes.DateTime;
    type Reciever = TransactionTypes.Reciever;
    type Status = TransactionTypes.Status;
    type TransactionType = SharedTypes.TransactionType;
    type BitcoinTransactionObj = BitcoinTransaction.BitcoinTransaction;
    type TransactionTypeShared = TransactionTypes.TransactionTypeShared;
    type ProofOfConceptTransaction = ProofOfConceptTransaction.ProofOfConceptTransaction;
    type POCTransactionDetails = TransactionTypes.POCTransactionDetails;

    public func getTransactionId() : async Text {
        switch (transaction) {
            case (#BTC(transaction)) { await transaction.getTransactionId() };
            case (#POC(transaction)) { await transaction.getTransactionId() };
        };
    };

    public func getAmounts() : async [Amount] {
        switch (transaction) {
            case (#BTC(transaction)) { await transaction.getAmounts() };
            case (#POC(transaction)) { await transaction.getAmounts() };
        };
    };

    public func getReceivedTime() : async TransactionTypes.DateTime {
        switch (transaction) {
            case (#BTC(transaction)) { await transaction.getReceivedTime() };
            case (#POC(transaction)) { await transaction.getReceivedTime() };
        };
    };

    public func getReceivers() : async [TransactionTypes.Reciever] {
        switch (transaction) {
            case (#BTC(transaction)) { await transaction.getReceivers() };
            case (#POC(transaction)) { await transaction.getReceivers() };
        };
    };

    public func getEntityId() : async Nat {
        switch (transaction) {
            case (#BTC(transaction)) { await transaction.getEntityId() };
            case (#POC(transaction)) { await transaction.getEntityId() };
        };
    };

    public func getEntityName() : async Text {
        switch (transaction) {
            case (#BTC(transaction)) { await transaction.getEntityName() };
            case (#POC(transaction)) { await transaction.getEntityName() };
        };
    };

    public func getStatus() : async TransactionTypes.Status {
        switch (transaction) {
            case (#BTC(transaction)) { await transaction.getStatus() };
            case (#POC(transaction)) { await transaction.getStatus() };
        };
    };

    public func confirmTransaction(timeOfCheck : TransactionTypes.DateTime) : async TransactionTypes.Status {
        switch (transaction) {
            case (#BTC(transaction)) {
                await transaction.confirmTransaction(timeOfCheck);
            };
            case (#POC(transaction)) {
                await transaction.confirmTransaction(timeOfCheck);
            };
        };
    };

    public func getTransactionDetails() : async TransactionTypeShared {
        switch (transaction) {
            case (#BTC(transaction)) {
                #BTC(await transaction.getTransactionDetails());
            };
            case (#POC(transaction)) {
                #POC(await transaction.getTransactionDetails());
            };
        };
    };

    //
    public func getBtcTransactionDetails() : async BitcoinTransactionDetails {
        switch (transaction) {
            case (#BTC(transaction)) {
                await transaction.getTransactionDetails();
            };
            case (#POC(transaction)) {
                throw Error.reject("Not a BTC transaction");
            };
        };
    };

    public func getPOCTransactionDetails() : async POCTransactionDetails {
        switch (transaction) {
            case (#BTC(transaction)) {
                throw Error.reject("Not a proof of concept transaction");
            };
            case (#POC(transaction)) {
                await transaction.getTransactionDetails();
            };
        };
    };
};
