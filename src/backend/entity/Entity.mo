import Nat "mo:base/Nat";
import Text "mo:base/Text";
import Types "Types";

actor class Entity(id:Nat, name:Text, category:Types.Category){
    var entityID:Nat=id;
    var entityName:Text=name;
    var entityCategory:Types.Category=category;
    public query func getID(): async Nat{
        return entityID;
    };

    public query func getName(): async Text{
        return entityName;
    };

    public query func getCategory(): async Types.Category{
        return entityCategory;
    };

    public func setName(newName: Text):async (){
        entityName:= newName;
    };
    public func setCategory(newCategory: Types.Category): async(){
        entityCategory:=newCategory;
    };
};