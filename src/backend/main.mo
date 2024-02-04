import Text "mo:base/Text";

import BitcoinWallet "BitcoinWallet";
import BitcoinApi "BitcoinApi";
import Types "Types";
import Utils "Utils";
import Array "mo:base/Array";
import Iter "mo:base/Iter";
import Nat32 "mo:base/Nat32";
import Float "mo:base/Float";
import Int "mo:base/Int";

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

   public func get_last_utxo_block_height(address : Types.BitcoinAddress) : async Nat32 {
    let utxosRes = await get_utxos(address);
    let utxos = utxosRes.utxos;
    var lastHeight : Nat32 = 0;
    for (utxo in  utxos.vals()) {
      var height = utxo.height;
      if(height > lastHeight) {
        lastHeight := utxo.height;
      }
    };
    return lastHeight;
  };
};

