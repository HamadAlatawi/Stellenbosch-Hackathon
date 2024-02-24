import TransactionStorage "canister:backendTransactionStorage";
import TransactionTypes "../commons/TransactionTypes";
import SharedTypes "../commons/SharedTypes";
import Transaction "transactions/Transaction";

import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Cycles "mo:base/ExperimentalCycles";
import Float "mo:base/Float";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Nat "mo:base/Nat";

actor class TransactionSorting() {
    type TransactionTypeShared = TransactionTypes.TransactionTypeShared;
    type Transaction = Transaction.Transaction;

    stable var amountArrayASC : [TransactionTypeShared] = [];
    stable var amountArrayDESC : [TransactionTypeShared] = [];
    stable var iDArrayASC : [TransactionTypeShared] = [];
    stable var iDArrayDESC : [TransactionTypeShared] = [];
    stable var recipientArrayASC : [TransactionTypeShared] = [];
    stable var recipientArrayDESC : [TransactionTypeShared] = [];
    stable var senderArrayASC : [TransactionTypeShared] = [];
    stable var senderArrayDESC : [TransactionTypeShared] = [];

    public func getAllTransactionsSubset(pageNumber : Nat, pageSize : Nat) : async [TransactionTypeShared] {
        let reversedTotalTransactions = await TransactionStorage.getAllTransactions();
        let totalTransactions = Array.size(reversedTotalTransactions);
        var startIndex = (pageNumber - 1) * pageSize;
        var endIndex = Nat.min(startIndex + pageSize, totalTransactions);
        if (startIndex >= totalTransactions) {
            let outOfBoundsArray = getTransactionTypeListFromNonNullable(reversedTotalTransactions);
            return await outOfBoundsArray;
        };

        let sortedReversedArray = Iter.toArray(Array.slice(reversedTotalTransactions, startIndex, endIndex));
        return await getTransactionTypeListFromNonNullable(sortedReversedArray);
    };

    public func getCountOfAllTransactions() : async Nat {
        let array = await TransactionStorage.getAllTransactions();
        return array.size();
    };

    public func getAllTransactionsSubsetArrayArgs(sortedSliced : [TransactionTypeShared], pageNumber : Nat, pageSize : Nat) : async [TransactionTypeShared] {
        let totalTransactions = Array.size(sortedSliced);
        var startIndex = (pageNumber - 1) * pageSize;
        var endIndex = Nat.min(startIndex + pageSize, totalTransactions);
        if (startIndex >= totalTransactions) {
            return sortedSliced;
        };

        let sortedReversedArray = Iter.toArray(Array.slice(sortedSliced, startIndex, endIndex));
        return sortedReversedArray;
    };

    public func getAllTransactionTypes(pageNumber : Nat, pageSize : Nat) : async [TransactionTypeShared] {
        let slicedTransactions = await getAllTransactionsSubset(pageNumber, pageSize);
        return slicedTransactions;
    };

    public func mapSortingArray(array : [TransactionTypeShared], sortField : Text, isAscending : Bool, transactionArray : [TransactionTypeShared]) : async [TransactionTypeShared] {
        if (array.size() != transactionArray.size()) {
            switch (sortField, isAscending) {
                case ("ID", true) {
                    iDArrayASC := transactionArray;
                    return iDArrayASC;
                };
                case ("ID", false) {
                    iDArrayDESC := transactionArray;
                    return iDArrayDESC;
                };
                case ("Amount", true) {
                    amountArrayASC := transactionArray;
                    return amountArrayASC;
                };
                case ("Amount", false) {
                    amountArrayDESC := transactionArray;
                    return amountArrayDESC;
                };
                case ("Recipient", true) {
                    recipientArrayASC := transactionArray;
                    return recipientArrayASC;
                };
                case ("Recipient", false) {
                    recipientArrayDESC := transactionArray;
                    return recipientArrayDESC;
                };
                case ("Sender", true) {
                    senderArrayASC := transactionArray;
                    return senderArrayASC;
                };
                case ("Sender", false) {
                    senderArrayDESC := transactionArray;
                    return senderArrayDESC;
                };
                case (_, _) { return transactionArray };
            };
        } else {
            return array;
        };
    };

    public func updateSortingArray(array : [TransactionTypeShared], sortField : Text, isAscending : Bool, transactionArray : [TransactionTypeShared]) : async [TransactionTypeShared] {
        let transactionArrayCase : [TransactionTypeShared] = switch (sortField, isAscending) {
            case ("ID", true) {
                iDArrayASC := array;
                return iDArrayASC;
            };
            case ("ID", false) {
                iDArrayDESC := array;
                return iDArrayDESC;
            };
            case ("Amount", true) {
                amountArrayASC := array;
                return amountArrayASC;
            };
            case ("Amount", false) {
                amountArrayDESC := array;
                return amountArrayDESC;
            };
            case ("Recipient", true) {
                recipientArrayASC := array;
                return recipientArrayASC;
            };
            case ("Recipient", false) {
                recipientArrayDESC := array;
                return recipientArrayDESC;
            };
            case ("Sender", true) {
                senderArrayASC := array;
                return senderArrayASC;
            };
            case ("Sender", false) {
                senderArrayDESC := array;
                return senderArrayDESC;
            };
            case (_, _) {
                return transactionArray;
            };
        };
    };

    public func getSortedArray(sortField : Text, isAscending : Bool, transactionArray : [TransactionTypeShared]) : async [TransactionTypeShared] {
        let sortedArray : [TransactionTypeShared] = switch (sortField, isAscending) {
            case ("ID", true) { iDArrayASC };
            case ("ID", false) { iDArrayDESC };
            case ("Amount", true) { amountArrayASC };
            case ("Amount", false) { amountArrayDESC };
            case ("Recipient", true) { recipientArrayASC };
            case ("Recipient", false) { recipientArrayDESC };
            case ("Sender", true) { senderArrayASC };
            case ("Sender", false) { senderArrayDESC };
            case (_, _) { transactionArray };
        };
        return sortedArray;
    };

    private func merge<T>(left : [T], right : [T], isAscending : Bool, compareFunc : (T, T) -> Bool) : [T] {
        var result = Buffer.Buffer<T>(0);
        var i = 0;
        var j = 0;

        while (i < left.size() and j < right.size()) {
            var shouldAppendLeft : Bool = false;

            if (isAscending) {
                shouldAppendLeft := compareFunc(left[i], right[j]);
            } else {
                shouldAppendLeft := compareFunc(right[j], left[i]);
            };

            if (shouldAppendLeft) {
                result.add(left[i]);
                i += 1;
            } else {
                result.add(right[j]);
                j += 1;
            };
        };

        while (i < left.size()) {
            result.add(left[i]);
            i += 1;
        };

        while (j < right.size()) {
            result.add(right[j]);
            j += 1;
        };

        let comparedArray = Buffer.toArray<T>(result);
        return comparedArray;
    };

    private func mergeSort<T>(array : [TransactionTypeShared], isAscending : Bool, compareFunc : (TransactionTypeShared, TransactionTypeShared) -> Bool) : async [TransactionTypeShared] {
        if (Array.size(array) <= 1) {
            return array;
        };

        let mid : Nat = Array.size(array) / 2;
        let left = await mergeSort(Iter.toArray(Array.slice(array, 0, mid)), isAscending, compareFunc);
        let right = await mergeSort(Iter.toArray(Array.slice(array, mid, Array.size(array))), isAscending, compareFunc);

        return merge(left, right, isAscending, compareFunc);
    };

    public func sortTransactionTypes(pageNumber : Nat, pageSize : Nat, sortField : Text, isAscending : Bool) : async [TransactionTypeShared] {
        let reversedTotalTransactions = await getTransactionTypeListFromNonNullable(await TransactionStorage.getAllTransactions());
        let caseArray = await getSortedArray(sortField, isAscending, reversedTotalTransactions);

        if (reversedTotalTransactions.size() != caseArray.size()) {
            let sortedMappedCaseArray = await mapSortingArray(caseArray, sortField, isAscending, reversedTotalTransactions);
            let compareFunc = func(t1 : TransactionTypeShared, t2 : TransactionTypeShared) : Bool {
                switch (sortField) {
                    case ("ID") {
                        return getIdFromTransaction(t1) < getIdFromTransaction(t2);
                    };
                    case ("Recipient") {
                        return getRecipientFromTransaction(t1) < getRecipientFromTransaction(t2);
                    };
                    case ("Sender") {
                        return getSourceAddressFromTransaction(t1) < getSourceAddressFromTransaction(t2);
                    };
                    case ("AmountBtc") {
                        return getAmountBtc(t1) > getAmountBtc(t2);
                    };
                    case ("AmountPoc") {
                        return getAmountPoc(t1) > getAmountPoc(t2);
                    };
                    case (_) { false };
                };
            };
            let sortedSlice = await mergeSort(sortedMappedCaseArray, isAscending, compareFunc);
            let replaceValues = await updateSortingArray(sortedSlice, sortField, isAscending, reversedTotalTransactions);
            let slicedTransactions = await getAllTransactionsSubsetArrayArgs(replaceValues, pageNumber, pageSize);
            return slicedTransactions;
        } else {
            return await getAllTransactionsSubsetArrayArgs(caseArray, pageNumber, pageSize);
        };
    };

    //HELPER FUNCTIONS
    public func getTransactionTypeListFromNonNullable(transactions : [Transaction]) : async [TransactionTypeShared] {
        let transactionTypeBuffer = Buffer.Buffer<TransactionTypeShared>(0);
        for (transaction in transactions.vals()) {
            transactionTypeBuffer.add(await transaction.getTransactionDetails());
        };
        return Buffer.toArray(transactionTypeBuffer);
    };

    private func getIdFromTransaction(transaction : TransactionTypeShared) : Text {
        switch (transaction) {
            case (#BTC(t1)) { t1.commonTransactionDetails.transactionId };
            case (#POC(t1)) {
                t1.commonTransactionDetails.transactionId;
            };
        };
    };

    private func getSourceAddressFromTransaction(transaction : TransactionTypeShared) : Text {
        switch (transaction) {
            case (#BTC(t1)) { t1.sourceBtcAddress };
            case (#POC(t1)) { "" };
        };
    };

    private func getRecipientFromTransaction(transaction : TransactionTypeShared) : Text {
        switch (transaction) {
            case (#BTC(t1)) {
                t1.commonTransactionDetails.receivingEntityName;
            };
            case (#POC(t1)) {
                t1.commonTransactionDetails.receivingEntityName;
            };
        };
    };

    private func getAmountBtc(transaction : TransactionTypeShared) : Float {
        switch (transaction) {
            case (#BTC(transaction)) {
                let amounts = transaction.commonTransactionDetails.amounts;
                getAmountPerCurrency(amounts, #satoshi);
            };
            case (#POC(transaction)) {
                return 0.0;
            };
        };
    };

    private func getAmountPoc(transaction : TransactionTypeShared) : Float {
        switch (transaction) {
            case (#BTC(transaction)) {
                return 0.0;
            };
            case (#POC(transaction)) {
                let amounts = transaction.commonTransactionDetails.amounts;
                getAmountPerCurrency(amounts, #proofOfConcept);
            };
        };
    };

    private func getAmountPerCurrency(amounts : [TransactionTypes.Amount], currency : TransactionTypes.Currency) : Float {
        for (amount in amounts.vals()) {
            if (amount.currency == currency) {
                return amount.amount;
            };
        };
        return 0.0;
    };
};
