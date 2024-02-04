import MyDateTime "MyDateTime";
module Types {
    public type Amount = {
        amountBTC : Float;
        amountInSatoshi : Float;
    };
    public type Beneficiary = {
        #entity;
        #token;
        #education;
        #development;
        #infrastructure;
    };
    public type Reciever = {
        amount : Amount;
        percentage : Float;
        benificiary : Beneficiary;
    };

    public type Status = {
        #confirmed;
        #pending;
        #rejected;
    };

    public type MyDateTime = MyDateTime.MyDateTime;

};
