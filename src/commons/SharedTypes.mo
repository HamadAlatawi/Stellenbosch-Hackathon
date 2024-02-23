import ProofOfConceptTransaction "../backendTransactionStorage/transactions/ProofOfConceptTransaction";
import BitcoinTransaction "../backendTransactionStorage/transactions/BitcoinTransaction";

module SharedTypes {
    public type TransactionType = {
        #BTC : BitcoinTransaction.BitcoinTransaction;
        #POC : ProofOfConceptTransaction.ProofOfConceptTransaction;
    };
};
