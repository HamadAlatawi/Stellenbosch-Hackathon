import Types "Types";
import BasicBitcoin "canister:backend"; 
import Float "mo:base/Float";
import Transactions "Transactions";
import Transaction "Transaction";
actor Main {
  type Transactions = Transactions.Transactions;  
//   stable let TRANSACTIONS_STORAGE : Transactions = async Transactions.Transactions();
  public func createTransaction(address : Types.BitcoinAddress, sourceAddress : Types.BitcoinAddress, amount : Types.Amount, receivers : [Types.Reciever], entityID : Nat) : async () {
    var lastBalance = await BasicBitcoin.get_balance(address);
    var lastBlockHeight = await BasicBitcoin.get_last_utxo_block_height(address);
    let status : Types.Status = #pending;
    // var T =  TRANSACTIONS_STORAGE.createTransaction(sourceAddress, amount, receivers, entityID, status, lastBalance, lastBlockHeight);
  };
}