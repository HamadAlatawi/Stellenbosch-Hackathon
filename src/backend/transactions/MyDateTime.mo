import Array "mo:base/Array";
import Time "mo:base/Time";

actor class MyDateTime() {
    let dateTime : Time.Time = Time.now();

    public query func getDateTime() : async Time.Time {
        return dateTime;
    };

    public func getTimeElapsed(baseTime : Time.Time) : async Int {
        return baseTime - dateTime;
    };
};