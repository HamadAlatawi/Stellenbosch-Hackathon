import Transactions "canister:backendTransaction";


import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Cycles "mo:base/ExperimentalCycles";
import ExperimentalCycles "mo:base/ExperimentalCycles";
import Float "mo:base/Float";
import Iter "mo:base/Iter";
import List "mo:base/List";
import Nat "mo:base/Nat";
import Transaction "../backendTransaction/Transaction";

import Types "../commons/Types";

actor class SortingMain() {
    type TransactionType = Types.TransactionType;
    type Transaction = Transaction.Transaction;


    stable var amountArrayASC : [TransactionType] = [];
    stable var amountArrayDESC : [TransactionType] = [];
    stable var iDArrayASC : [TransactionType] = [];
    stable var iDArrayDESC : [TransactionType] = [];
    stable var recipientArrayASC : [TransactionType] = [];
    stable var recipientArrayDESC : [TransactionType] = [];
    stable var senderArrayASC : [TransactionType] = [];
    stable var senderArrayDESC : [TransactionType] = [];

    public func getAllTransactionsSubset(pageNumber : Nat, pageSize : Nat) : async [TransactionType] {
        let reversedTotalTransactions = await Transactions.getAllTransactions();
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
        let array = await Transactions.getAllTransactions();
        return array.size();
    };

    public func getAllTransactionsSubsetArrayArgs(sortedSliced : [TransactionType], pageNumber : Nat, pageSize : Nat) : async [TransactionType] {
        let totalTransactions = Array.size(sortedSliced);
        var startIndex = (pageNumber - 1) * pageSize;
        var endIndex = Nat.min(startIndex + pageSize, totalTransactions);
        if (startIndex >= totalTransactions) {
            return sortedSliced;
        };

        let sortedReversedArray = Iter.toArray(Array.slice(sortedSliced, startIndex, endIndex));
        return sortedReversedArray;
    };

    public func getAllTransactionTypes(pageNumber : Nat, pageSize : Nat) : async [TransactionType] {
        let slicedTransactions = await getAllTransactionsSubset(pageNumber, pageSize);
        return slicedTransactions;
    };

    public func mapSortingArray(array : [TransactionType], sortField : Text, isAscending : Bool, transactionArray : [TransactionType]) : async [TransactionType] {
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

    public func updateSortingArray(array : [TransactionType], sortField : Text, isAscending : Bool, transactionArray : [TransactionType]) : async [TransactionType] {
        let transactionArrayCase : [TransactionType] = switch (sortField, isAscending) {
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

    public func getSortedArray(sortField : Text, isAscending : Bool, transactionArray : [TransactionType]) : async [TransactionType] {
        let sortedArray : [TransactionType] = switch (sortField, isAscending) {
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

    private func mergeSort<T>(array : [TransactionType], isAscending : Bool, compareFunc : (TransactionType, TransactionType) -> Bool) : async [TransactionType] {
        if (Array.size(array) <= 1) {
            return array;
        };

        let mid : Nat = Array.size(array) / 2;
        let left = await mergeSort(Iter.toArray(Array.slice(array, 0, mid)), isAscending, compareFunc);
        let right = await mergeSort(Iter.toArray(Array.slice(array, mid, Array.size(array))), isAscending, compareFunc);

        return merge(left, right, isAscending, compareFunc);
    };

    public func sortTransactionTypes(pageNumber : Nat, pageSize : Nat, sortField : Text, isAscending : Bool) : async [TransactionType] {
        let reversedTotalTransactions = await getTransactionTypeListFromNonNullable(await Transactions.getAllTransactions());
        let caseArray = await getSortedArray(sortField, isAscending, reversedTotalTransactions);

        if (reversedTotalTransactions.size() != caseArray.size()) {
            let sortedMappedCaseArray = await mapSortingArray(caseArray, sortField, isAscending, reversedTotalTransactions);
            let compareFunc = func(t1 : TransactionType, t2 : TransactionType) : Bool {
                switch (sortField) {
                    case ("ID") {
                        return t1.transactionID < t2.transactionID;
                    };
                    case ("Recipient") {
                        return t1.transactionReceivers[0].benificiary.donation < t2.transactionReceivers[0].benificiary.donation;
                    };
                    case ("Sender") {
                        return t1.sourceBTCAddy < t2.sourceBTCAddy;
                    };
                    case ("Amount") {
                        return t1.transactionAmount.amountBTC > t2.transactionAmount.amountBTC;
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

    public func getTransactionTypeListFromNonNullable(transactions : [Transaction]) : async [TransactionType] {
        let transactionTypeBuffer = Buffer.Buffer<TransactionType>(0);
        for (transaction in transactions.vals()) {
            transactionTypeBuffer.add(await Transactions.getTransactionTypeFrom(transaction));
        };
        return Buffer.toArray(transactionTypeBuffer);
    };
};