import BasicBitcoin "canister:backend";

import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Float "mo:base/Float";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Nat32 "mo:base/Nat32";
import Time "mo:base/Time";
import { recurringTimer; setTimer } "mo:base/Timer";
import Text "mo:base/Text";

import BitcoinApi "../backend/BitcoinApi";
import Types "../commons/Types";
import MyDateTime "MyDateTime";
import Transaction "Transaction";
import Transactions "Transactions";

actor class TransactionsMain(address : Types.BitcoinAddress) {
    type BlockHeight = Types.BlockHeight;
    type Transaction = Transaction.Transaction;
    type Utxo = Types.Utxo;
    type Block = Types.Block;
    stable var transactionArray : [Transaction] = [];
    var transactionBuffer = Buffer.fromArray<Transaction>(transactionArray);
    let canisterBitcoinAddress = address;
    let intervalSecondsForTimer = 86400; // Set your desired interval here
    stable var processedBlocksArr : [BlockHeight] = [];
    var processedBlocksBuffer = Buffer.fromArray<BlockHeight>(processedBlocksArr);

    public func createTransaction(transactionID : Text, source : Text, amount : Types.Amount, receivers : [Types.Reciever], entityID : Nat, status : Types.Status, lastCanisterBalanceInSatoshi : Types.Satoshi, lastBlockInCanisterHeight : Nat32) : async Transaction {
        let dateTime = await MyDateTime.MyDateTime();
        let trans = await Transaction.Transaction(transactionID, source, amount, dateTime, receivers, entityID, status, lastCanisterBalanceInSatoshi, lastBlockInCanisterHeight);
        return trans;
    };

    public func storeTransaction(transaction : Transaction) : async () {
        transactionBuffer.add(transaction);
        transactionArray := Buffer.toArray<Transaction>(transactionBuffer);
    };

    public query func getAllTransactions() : async [Transaction] {
        return transactionArray;
    };

    public func getTransactionById(id : Text) : async ?Transaction {
        let transactionArr = await getAllTransactions();
        for (transaction in transactionArr.vals()) {
            let transactionId = await transaction.getID();
            if (transactionId == id) {
                switch (?transaction) {
                    case (null) {};
                    case (transaction) { return transaction };
                };
            };
        };
        return null;
    };

    public func createAndAddTransaction(transactionID : Text, sourceAddress : Types.BitcoinAddress, amount : Types.Amount, receivers : [Types.Reciever], entityID : Nat) : async () {
        var lastBalance = await BasicBitcoin.get_balance(canisterBitcoinAddress);
        var lastBlockHeight = await BasicBitcoin.get_last_utxo_block_height(canisterBitcoinAddress);
        let status : Types.Status = #pending;
        var transaction = await createTransaction(transactionID, sourceAddress, amount, receivers, entityID, status, lastBalance, lastBlockHeight);
        await storeTransaction(transaction);
    };

    public func getTransactionByStatus(status : Types.Status) : async [Transaction] {
        let buffer = Buffer.Buffer<Transaction>(transactionArray.size());
        for (transaction in transactionArray.vals()) {
            let transactionStatus = await transaction.getStatus();
            if (transactionStatus == status) {
                buffer.add(transaction);
            };
        };
        return Buffer.toArray(buffer);
    };

    public func updateTransactionStatus() : async () {
        var utxoResponse = await BasicBitcoin.get_blocks(canisterBitcoinAddress);
        var unprocessedUtxos = await getUnprocessed(utxoResponse);
        var currentBalance = await BasicBitcoin.get_balance(canisterBitcoinAddress);
        var currentTime = Time.now();
        var pendingTransactions = await getTransactionByStatus(#pending);
        for (transaction in pendingTransactions.vals()) {
            label processUtxos for (utxo in unprocessedUtxos.vals()) {
                let status = await transaction.updateTransactionStatus(utxo.height, utxo.value, currentBalance, currentTime);
                switch status {
                    case (#confirmed) {
                        await updateProcessedBlocks(utxo.height);
                        break processUtxos;
                    };
                    case (#rejected) {
                        break processUtxos;
                    };
                    case (#pending) continue processUtxos;
                };
            };
        };
    };

    public func updateProcessedBlocks(height : BlockHeight) : async () {
        processedBlocksBuffer.add(height);
        processedBlocksArr := Buffer.toArray(processedBlocksBuffer);
    };

    public func getAllprocessedBlocks(height : BlockHeight) : async [BlockHeight] {
        processedBlocksArr;
    };

    public func getUnprocessed(utxos : [Block]) : async [Block] {
        var utxoBuf = Buffer.Buffer<Block>(utxos.size());
        for (utxo in utxos.vals()) {
            var height = utxo.height;
            let found = await isProcessed(height);
            if (not found) {
                utxoBuf.add(utxo);
            };
        };
        Buffer.toArray(utxoBuf);
    };

    public func isProcessed(x : BlockHeight) : async Bool {
        for (block in processedBlocksArr.vals()) {
            if (block == x) {
                return true;
            };
        };
        return false;
    };
    // ignore recurringTimer(#seconds intervalSecondsForTimer, updateTransactionStatus);
};
