export const idlFactory = ({ IDL }) => {
  const Network = IDL.Variant({
    'mainnet' : IDL.Null,
    'regtest' : IDL.Null,
    'testnet' : IDL.Null,
  });
  const BitcoinAddress__1 = IDL.Text;
  const Satoshi__1 = IDL.Nat64;
  const MillisatoshiPerVByte = IDL.Nat64;
  const Page = IDL.Vec(IDL.Nat8);
  const BlockHash = IDL.Vec(IDL.Nat8);
  const Satoshi = IDL.Nat64;
  const OutPoint = IDL.Record({
    'txid' : IDL.Vec(IDL.Nat8),
    'vout' : IDL.Nat32,
  });
  const Utxo = IDL.Record({
    'height' : IDL.Nat32,
    'value' : Satoshi,
    'outpoint' : OutPoint,
  });
  const GetUtxosResponse = IDL.Record({
    'next_page' : IDL.Opt(Page),
    'tip_height' : IDL.Nat32,
    'tip_block_hash' : BlockHash,
    'utxos' : IDL.Vec(Utxo),
  });
  const BitcoinAddress = IDL.Text;
  const TransactionDetails = IDL.Record({
    'confirmation' : IDL.Nat,
    'recipientAddress' : BitcoinAddress,
    'amount' : Satoshi,
    'senderAddress' : BitcoinAddress,
  });
  const SendRequest = IDL.Record({
    'destination_address' : IDL.Text,
    'amount_in_satoshi' : Satoshi,
  });
  const BasicBitcoin = IDL.Service({
    'get_balance' : IDL.Func([BitcoinAddress__1], [Satoshi__1], []),
    'get_current_fee_percentiles' : IDL.Func(
        [],
        [IDL.Vec(MillisatoshiPerVByte)],
        [],
      ),
    'get_p2pkh_address' : IDL.Func([], [BitcoinAddress__1], []),
    'get_utxos' : IDL.Func([BitcoinAddress__1], [GetUtxosResponse], []),
    'processTransaction' : IDL.Func(
        [IDL.Text, Network],
        [TransactionDetails],
        [],
      ),
    'send' : IDL.Func([SendRequest], [IDL.Text], []),
  });
  return BasicBitcoin;
};
export const init = ({ IDL }) => {
  const Network = IDL.Variant({
    'mainnet' : IDL.Null,
    'regtest' : IDL.Null,
    'testnet' : IDL.Null,
  });
  return [Network];
};
