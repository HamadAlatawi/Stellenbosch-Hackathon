import Int "mo:base/Int";
import ExperimentalCycles "mo:base/ExperimentalCycles";
import Time "mo:base/Time";
import TransactionTypes "../../commons/TransactionTypes";
import Types "../../commons/Types";
import CommonTransaction "CommonTransaction";
import HttpTypes "../../commons/HttpTypes";
import JSON "../../commons/json/JSON";
import Blob "mo:base/Blob";
import Text "mo:base/Text";
import Buffer "mo:base/Buffer";
import Error "mo:base/Error";
import Array "mo:base/Array";
import Nat64 "mo:base/Nat64";
import Float "mo:base/Float";
import Debug "mo:base/Debug";

actor class BitcoinTransaction(transactionDetails : TransactionTypes.BitcoinTransactionDetails) : async CommonTransaction.CommonTransaction {
    type BitcoinTransactionDetails = TransactionTypes.BitcoinTransactionDetails;
    type Amount = TransactionTypes.Amount;
    type DateTime = TransactionTypes.DateTime;
    type Reciever = TransactionTypes.Reciever;
    type Status = TransactionTypes.Status;
    type BitcoinAddress = Types.BitcoinAddress;
    type TransactionConfiramtionDetails = TransactionTypes.BtcTransactionConfiramtionDetails;

    let receivedTime : DateTime = transactionDetails.commonTransactionDetails.receivedTime;
    let transactionId : Text = transactionDetails.commonTransactionDetails.transactionId;
    let sourceBtcAddress : BitcoinAddress = transactionDetails.sourceBtcAddress;
    var amounts : [Amount] = transactionDetails.commonTransactionDetails.amounts;
    var receivers : [Reciever] = transactionDetails.commonTransactionDetails.receivers;
    let receivingEntityId : Nat = transactionDetails.commonTransactionDetails.receivingEntityId;
    let receivingEntityName : Text = transactionDetails.commonTransactionDetails.receivingEntityName;
    let receivingAddress : Text = transactionDetails.receivingAddress;
    var status : Status = transactionDetails.commonTransactionDetails.status;

    public query func getTransactionId() : async Text {
        return transactionId;
    };

    public query func getSourceAddress() : async Text {
        return sourceBtcAddress;
    };

    public query func getAmounts() : async [Amount] {
        return amounts;
    };

    public query func getReceivedTime() : async DateTime {
        return receivedTime;
    };

    public query func getReceivers() : async [Reciever] {
        return receivers;
    };

    public query func getEntityId() : async Nat {
        return receivingEntityId;
    };

    public query func getEntityName() : async Text {
        return receivingEntityName;
    };

    public query func getStatus() : async Status {
        return status;
    };

    public func confirmTransaction(timeOfCheck : DateTime) : async Status {
        let twoDays : Int = 2;
        let daysPassedSince = TransactionTypes.daysPassedSince(timeOfCheck, receivedTime);
        if (daysPassedSince <= twoDays) {
            let confirmationDetails = await getTransactionConfirmationDetails(transactionId);
            // check that the receivingAddress is contained in the transaction addresses to confirm that it is in fact for the cansiter address and not a any transaction
            if (Array.find<Text>(confirmationDetails.addresses, func x = Text.equal(x, receivingAddress)) != null) {
                // 6 confirmations are standard to confirm even large bitcoin transactions
                if (confirmationDetails.confirmations >= 6) {
                    let satoshiAmount = confirmationDetails.satoshiAmount;
                    // If the user passed the wrong amount, i.e. not the same as the transaction; then mutate the amounts
                    mutateAmountIfIncorrectForConfirmed(satoshiAmount);
                    status := #confirmed;
                };
            } else {
                status := #rejected;
            };

        } else if (daysPassedSince > twoDays) {
            status := #rejected;
        };
        return status;
    };

    public func getTransactionDetails() : async BitcoinTransactionDetails {
        return {
            commonTransactionDetails = {
                transactionId = transactionId;
                amounts = amounts;
                receivers = receivers;
                receivingEntityId = receivingEntityId;
                receivingEntityName = receivingEntityName;
                status = status;
                receivedTime = receivedTime;
            };
            sourceBtcAddress = sourceBtcAddress;
            receivingAddress = receivingAddress;
        };
    };

    private func mutateAmountIfIncorrectForConfirmed(satoshiAmount : Float) : () {
        for (amount in amounts.vals()) {
            if (amount.currency == #satoshi) {
                if (amount.amount == satoshiAmount) {
                    return;
                } else {
                    amounts := [{ amount = satoshiAmount; currency = #satoshi }, { amount = satoshiAmount / TransactionTypes.SATOSHI_TO_BTC_RATE; currency = #bitcoin }];
                    receivers := mutateRecievers(satoshiAmount);
                };
            };
        };
    };

    private func mutateRecievers(satoshiAmount : Float) : [Reciever] {
        var mutatedReceivers = Buffer.Buffer<Reciever>(receivers.size());
        for (receiver in receivers.vals()) {
            let percentage = receiver.percentage;
            let newSatoshiAmount = percentage * satoshiAmount;
            let newAmounts = [{ amount = newSatoshiAmount; currency = #satoshi }, { amount = newSatoshiAmount / TransactionTypes.SATOSHI_TO_BTC_RATE; currency = #bitcoin }];
            mutatedReceivers.add({
                amounts = newAmounts;
                percentage = percentage;
                benificiary = receiver.benificiary;
            });
        };
        return Buffer.toArray(mutatedReceivers);
    };

    //CONFIRMATION LOGIC
    public func getTransactionConfirmationDetails(txidHash : Text) : async TransactionConfiramtionDetails {
        let ic : HttpTypes.IC = actor ("aaaaa-aa");

        let host : Text = "api.blockcypher.com";
        let url = "https://" # host # "/v1/btc/test3/txs/" # txidHash;

        let requestHeaders = [
            { name = "Host"; value = host # ":443" },
        ];

        let transformContext : HttpTypes.TransformContext = {
            function = transform;
            context = Blob.fromArray([]);
        };

        let httpRequest : HttpTypes.HttpRequestArgs = {
            url = url;
            max_response_bytes = null;
            headers = requestHeaders;
            body = null;
            method = #get;
            transform = ?transformContext;
        };

        ExperimentalCycles.add(HttpTypes.HTTP_REQUEST_CYCLES_COST);

        let httpResponse : HttpTypes.HttpResponsePayload = await ic.http_request(httpRequest);

        let responseBody : Blob = Blob.fromArray(httpResponse.body);
        let decodedResponse = switch (Text.decodeUtf8(responseBody)) {
            case (null) { throw Error.reject("Transaction Not Found!") };
            case (?decoded_text) { decoded_text };
        };
        await parseConfirmationDetails(decodedResponse);
    };

    private func parseConfirmationDetails(decodedResponse : Text) : async TransactionConfiramtionDetails {
        let jsonResponse : JSON.JSON = switch (JSON.parse(decodedResponse)) {
            case (?jsonResponse) { jsonResponse };
            case (null) { throw Error.reject("Not Valid JSON Response") };
        };
        var addresses = Buffer.Buffer<Text>(0);
        var confirmations : Int = 0;
        var satoshiAmount : Int = 0;

        switch (jsonResponse) {
            case (#Object(jsonResponse)) {
                label jsonIter for ((k, v) in jsonResponse.vals()) {
                    if (Text.equal(k, "addresses")) {
                        switch (v) {
                            case (#Array(v)) {
                                for (address in v.vals()) {
                                    switch (address) {
                                        case (#String(address)) {
                                            addresses.add(address);
                                        };
                                        case (_) {};
                                    };
                                };
                            };
                            case (_) {};
                        };
                    };

                    if (Text.equal(k, "total")) {
                        switch (v) {
                            case (#Number(v)) { satoshiAmount := v };
                            case (_) {};
                        };
                    };

                    if (Text.equal(k, "confirmations")) {
                        switch (v) {
                            case (#Number(v)) { confirmations := v };
                            case (_) {};
                        };
                        break jsonIter;
                    };
                };
            };
            case (_) { throw Error.reject("Not Valid JSON Response") };
        };
        {
            addresses = Buffer.toArray(addresses);
            confirmations = confirmations;
            satoshiAmount = Float.fromInt(satoshiAmount);
        };
    };

    public query func transform(raw : HttpTypes.TransformArgs) : async HttpTypes.CanisterHttpResponsePayload {
        let transformed : HttpTypes.CanisterHttpResponsePayload = {
            status = raw.response.status;
            body = raw.response.body;
            headers = [
                {
                    name = "Content-Security-Policy";
                    value = "default-src 'self'";
                },
                { name = "Referrer-Policy"; value = "strict-origin" },
                { name = "Permissions-Policy"; value = "geolocation=(self)" },
                {
                    name = "Strict-Transport-Security";
                    value = "max-age=63072000";
                },
                { name = "X-Frame-Options"; value = "DENY" },
                { name = "X-Content-Type-Options"; value = "nosniff" },
            ];
        };
        transformed;
    };
};
