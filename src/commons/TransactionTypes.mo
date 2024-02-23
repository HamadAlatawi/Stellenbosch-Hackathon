import Float "mo:base/Float";
import Text "mo:base/Text";
import Time "mo:base/Time";

module TransactionTypes {
    //STATICS
    public let hourInNanoSecounds : Int = 86400000000000;

    //FUNCTIONS
    public func getTimeElapsed(baseTime : DateTime, receivedTime : DateTime) : async Int {
        return baseTime - receivedTime;
    };

    public func didADayPassSince(baseTime : DateTime, receivedTime : DateTime) : async Bool {
        var difference = await getTimeElapsed(baseTime, receivedTime);
        difference >= hourInNanoSecounds;
    };

    // COMMON TRANSACTION  TYPES
    public type Amount = {
        amount : Float;
        currency : Currency;
    };

    public type Currency = {
        #bitcoin;
        #satoshi;
        #proofOfConcept;
    };

    public type Reciever = {
        amount : Amount;
        percentage : Float;
        benificiary : Text;
    };

    public type Status = {
        #confirmed;
        #pending;
        #rejected;
    };

    public type TransactionType = {
        #BTC;
        #POC;
    }; 

    public type DateTime = Time.Time;

    //TRANSACTION DETAILS

    public type CommonTransactionDetails = {
        transactionId : Text;
        amounts : [Amount];
        receivers : [Reciever];
        receivingEntityId : Nat;
        receivingEntityName : Text;
        status : Status;

    };

    public type BitcoinTransactionDetails = {
        commonTransactionDetails : CommonTransactionDetails;
        sourceBtcAddress : Text;
    };
};
