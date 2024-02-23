import ProofOfConceptTransaction "../transactions/ProofOfConceptTransaction";
import BitcoinTransaction "../transactions/BitcoinTransaction";

module SharedTypes {
    public type TransactionType = {
        #BTC : BitcoinTransaction.BitcoinTransaction;
        #POC : ProofOfConceptTransaction.ProofOfConceptTransaction;
    };
};
