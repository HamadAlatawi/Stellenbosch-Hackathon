module EntityTypes {
    public type Category = {
        #school;
        #student;
    };

    public type Entity = {
        id : Nat;
        name : Text;
        category : Category;
    };
};