import Text "mo:base/Text";
import Blob "mo:base/Blob";
import Nat8 "mo:base/Nat8";


import BitcoinWallet "BitcoinWallet";
import BitcoinApi "BitcoinApi";
import Types "Types";
import Utils "Utils";

actor class BasicBitcoin(_network : Types.Network) {
  type GetUtxosResponse = Types.GetUtxosResponse;
  type MillisatoshiPerVByte = Types.MillisatoshiPerVByte;
  type SendRequest = Types.SendRequest;
  type Network = Types.Network;
  type BitcoinAddress = Types.BitcoinAddress;
  type Satoshi = Types.Satoshi;
  type TransactionDetails = Types.TransactionDetails;

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
    case _ "test_key_1"
  };

  /// Returns the balance of the given Bitcoin address.
  public func get_balance(address : BitcoinAddress) : async Satoshi {
    await BitcoinApi.get_balance(NETWORK, address)
  };

  /// Returns the UTXOs of the given Bitcoin address.
  public func get_utxos(address : BitcoinAddress) : async GetUtxosResponse {
    await BitcoinApi.get_utxos(NETWORK, address)
  };

  /// Returns the 100 fee percentiles measured in millisatoshi/vbyte.
  /// Percentiles are computed from the last 10,000 transactions (if available).
  public func get_current_fee_percentiles() : async [MillisatoshiPerVByte] {
    await BitcoinApi.get_current_fee_percentiles(NETWORK)
  };

  /// Returns the P2PKH address of this canister at a specific derivation path.
  public func get_p2pkh_address() : async BitcoinAddress {
    await BitcoinWallet.get_p2pkh_address(NETWORK, KEY_NAME, DERIVATION_PATH)
  };

  /// Sends the given amount of bitcoin from this canister to the given address.
  /// Returns the transaction ID.
  public func send(request : SendRequest) : async Text {
    Utils.bytesToText(await BitcoinWallet.send(NETWORK, DERIVATION_PATH, KEY_NAME, request.destination_address, request.amount_in_satoshi))
  };

  // Method to retrieve and process transaction details TODO run using Motoko Timer
  public func processTransaction(transactionId : Text, network: Types.Network) : async Types.TransactionDetails {
      let transactionDetails = await getTransactionDetails(transactionId, network);
      let processedTransaction = await parseTransactionDetails(transactionDetails);
      //updateTransactionObject(processedTransaction);
      return processedTransaction;
  };

  // Function to fetch transaction details from the Bitcoin network using the canisters address.
  private func getTransactionDetails(transactionId : Text, network: Types.Network) : async Types.GetUtxosResponse {
      let address = await get_p2pkh_address();
      let transactionDetails = await get_utxos(address);
      return transactionDetails;
  };

  private func parseTransactionDetails(utxosResponse : Types.GetUtxosResponse) : async Types.TransactionDetails {
      let utxo = utxosResponse.utxos[0];
      let txidBlob = utxo.outpoint.txid;
      var txidText = "";
      for (byte : Nat8 in txidBlob.vals()) {
          txidText := Text.concat(txidText, Nat8.toText(byte));
      };
      let senderAddress = txidText;
      let recipientAddress = "dummy_recipient_address" : Types.BitcoinAddress;
      let amount = utxo.value;
      let confirmations = 1;
      return {
          senderAddress = senderAddress;
          recipientAddress = recipientAddress;
          amount = amount;
          confirmation = confirmations;
      };
  };

  // Function to update the transaction object in the backend database
  private func updateTransactionObject(transaction : Types.TransactionDetails) : async () {
      // Update the transaction object in the backend database
      // Implement your database logic here
  };

  // Function to find transaction details corresponding to the given transaction ID
  private func findTransactionDetails(transactionId : Text, utxos : Text) : Types.TransactionDetails {
      // Implement logic to find the transaction details from the list of UTXOs
      // For simplicity, returning a dummy transaction details object here
      return {
          senderAddress = "Sender Address";
          recipientAddress = "dummy_recipient_address";
          amount = 1000;
          confirmation = 6;
      };
  };
};