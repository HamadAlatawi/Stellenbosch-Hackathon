import Text "mo:base/Text";

import BitcoinWallet "BitcoinWallet";
import BitcoinApi "BitcoinApi";
import Types "Types";
import Utils "Utils";
// import BitcoinTransactionRequest "BitcoinTransactionRequest";
import Debug "mo:base/Debug";
import Blob "mo:base/Blob";
import Cycles "mo:base/ExperimentalCycles";
import Array "mo:base/Array";
import Nat8 "mo:base/Nat8";

actor class BasicBitcoin(_network : Types.Network) {
  type GetUtxosResponse = Types.GetUtxosResponse;
  type MillisatoshiPerVByte = Types.MillisatoshiPerVByte;
  type SendRequest = Types.SendRequest;
  type Network = Types.Network;
  type BitcoinAddress = Types.BitcoinAddress;
  type Satoshi = Types.Satoshi;

  // The Bitcoin network to connect to.
  //
  // When developing locally this should be `regtest`.
  // When deploying to the IC this should be `testnet`.
  // `mainnet` is currently unsupported.
  stable let NETWORK : Network = _network;

  // The derivation path to use for ECDSA secp256k1.
  let DERIVATION_PATH : [[Nat8]] = [];

  // The ECDSA key name.
  let KEY_NAME : Text = switch NETWORK {
    // For local development, we use a special test key with dfx.
    case (#regtest) "dfx_test_key";
    // On the IC we're using a test ECDSA key.
    case _ "test_key_1";
  };

  /// Returns the balance of the given Bitcoin address.
  public func get_balance(address : BitcoinAddress) : async Satoshi {
    await BitcoinApi.get_balance(NETWORK, address);
  };

  /// Returns the UTXOs of the given Bitcoin address.
  public func get_utxos(address : BitcoinAddress) : async GetUtxosResponse {
    await BitcoinApi.get_utxos(NETWORK, address);
  };

  /// Returns the 100 fee percentiles measured in millisatoshi/vbyte.
  /// Percentiles are computed from the last 10,000 transactions (if available).
  public func get_current_fee_percentiles() : async [MillisatoshiPerVByte] {
    await BitcoinApi.get_current_fee_percentiles(NETWORK);
  };

  /// Returns the P2PKH address of this canister at a specific derivation path.
  public func get_p2pkh_address() : async BitcoinAddress {
    await BitcoinWallet.get_p2pkh_address(NETWORK, KEY_NAME, DERIVATION_PATH);
  };

  /// Sends the given amount of bitcoin from this canister to the given address.
  /// Returns the transaction ID.
  public func send(request : SendRequest) : async Text {
    Utils.bytesToText(await BitcoinWallet.send(NETWORK, DERIVATION_PATH, KEY_NAME, request.destination_address, request.amount_in_satoshi));
  };

  // This function is used to transform the response received from our POST request
  public query func transform(raw : Types.TransformArgs) : async Types.CanisterHttpResponsePayload {
    let transformed : Types.CanisterHttpResponsePayload = {
      status = raw.response.status;
      body = raw.response.body;
      headers = [
        { name = "Content-Security-Policy"; value = "default-src 'self'" },
        { name = "Referrer-Policy"; value = "strict-origin" },
        { name = "Permissions-Policy"; value = "geolocation=(self)" },
        { name = "Strict-Transport-Security"; value = "max-age=63072000" },
        { name = "X-Frame-Options"; value = "DENY" },
        { name = "X-Content-Type-Options"; value = "nosniff" },
      ];
    };
    transformed;
  };

  // This function sends our POST request
  public func send_http_post_request_to_get_transaction(transactionId : Text) : async Text {
    // First, declare the management canister
    let ic : Types.IC = actor ("aaaaa-aa");

    // Next, setup the URL and its query parameters. This portion uses a free API.
    let host : Text = "127.0.0.1";
    let url = "http://127.0.0.1:18444";

    // Then, prepare headers for the system http_request call. Note that idempotency keys should be unique, so you create a function that generates them.
    let idempotency_key : Text = await generateUUID();
    let request_headers = [
      { name = "Host"; value = host # ":18444" },
      { name = "User-Agent"; value = "http_post_sample" },
      { name = "Content-Type"; value = "application/json" },
      { name = "Idempotency-Key"; value = idempotency_key },
    ];

    // Since the request body is an array of [Nat8], next you do the following:
    // 1. Write a JSON string
    // 2. Convert the Text into a Blob using Blob.fromText()
    // 3. Convert the Blob into an array [Nat8] using Blob.toArray()

    let request_body_json : Text = "{ \"txid\" : \"" # transactionId # "\",\"verbose\" : \"true\" }";
    let request_body_as_Blob : Blob = Text.encodeUtf8(request_body_json);
    let request_body_as_nat8 : [Nat8] = Blob.toArray(request_body_as_Blob);

    // Then you transform the content
    let transform_context : Types.TransformContext = {
      function = transform;
      context = Blob.fromArray([]);
    };

    // Next, you make the POST request
    let http_request : Types.HttpRequestArgs = {
      url = url;
      max_response_bytes = null; // optional for request
      headers = request_headers;
      body = ?request_body_as_nat8;
      method = #post;
      transform = ?transform_context;
    };

    // Now, you need to add some cycles to your call, since cycles to pay for the call must be transferred with the call.
    Cycles.add(21_850_258_000);

    // Now that you have the HTTP request and cycles to send with the call, you can make the HTTP request and await the response.
    let http_response : Types.HttpResponsePayload = await ic.http_request(http_request);

    // Once you have the response, you need to decode it. The body of the HTTP response should come back as [Nat8], which needs to be decoded into readable text.
    let response_body : Blob = Blob.fromArray(http_response.body);
    let decoded_text : Text = switch (Text.decodeUtf8(response_body)) {
      case (null) { "No value returned" };
      case (?y) { y };
    };

    // Finally, you can return the response body.
    let result : Text = decoded_text # ". See more info of the request sent at: " # url # "/inspect";
    result;
  };

  // As a final step, you define a private helper function that generates a universally unique identifier. In this exercise, it returns a constant, but in practice, it should return a unique identifier.
  public func generateUUID() : async Text {
    "UUID-123456789";
  };
};
