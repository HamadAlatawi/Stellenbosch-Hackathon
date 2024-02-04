import Array "mo:base/Array";
import Time "mo:base/Time";
import Text "mo:base/Text";

actor class MyDateTime() {
    let dateTime : Time.Time = Time.now();
    let hourInNanoSecounds : Int = 86400000000000; 

    public query func getDateTime() : async Time.Time {
        return dateTime;
    };

    public func getTimeElapsed(baseTime : Time.Time) : async Int {
        return baseTime - dateTime;
    };

    public func didADayPassSince(baseTime : Time.Time) : async Bool {
        var difference = await getTimeElapsed(baseTime);
        difference >= hourInNanoSecounds ;
    }
};