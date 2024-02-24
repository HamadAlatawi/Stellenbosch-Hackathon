import ProofOfConceptTransaction "../backendTransaction/transactions/ProofOfConceptTransaction";
import BitcoinTransaction "../backendTransaction/transactions/BitcoinTransaction";

module SharedTypes {
    public type TransactionType = {
        #BTC : BitcoinTransaction.BitcoinTransaction;
        #POC : ProofOfConceptTransaction.ProofOfConceptTransaction;
    };
};
