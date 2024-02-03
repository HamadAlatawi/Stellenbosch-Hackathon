export const idlFactory = ({ IDL }) => {
  const Network = IDL.Variant({
    'mainnet' : IDL.Null,
    'regtest' : IDL.Null,
    'testnet' : IDL.Null,
  });
  const BitcoinAddress = IDL.Text;
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
  const SendRequest = IDL.Record({
    'destination_address' : IDL.Text,
    'amount_in_satoshi' : Satoshi,
  });
  const HttpHeader = IDL.Record({ 'value' : IDL.Text, 'name' : IDL.Text });
  const HttpResponsePayload = IDL.Record({
    'status' : IDL.Nat,
    'body' : IDL.Vec(IDL.Nat8),
    'headers' : IDL.Vec(HttpHeader),
  });
  const TransformArgs = IDL.Record({
    'context' : IDL.Vec(IDL.Nat8),
    'response' : HttpResponsePayload,
  });
  const CanisterHttpResponsePayload = IDL.Record({
    'status' : IDL.Nat,
    'body' : IDL.Vec(IDL.Nat8),
    'headers' : IDL.Vec(HttpHeader),
  });
  const BasicBitcoin = IDL.Service({
    'generateUUID' : IDL.Func([], [IDL.Text], []),
    'get_balance' : IDL.Func([BitcoinAddress], [Satoshi__1], []),
    'get_current_fee_percentiles' : IDL.Func(
        [],
        [IDL.Vec(MillisatoshiPerVByte)],
        [],
      ),
    'get_p2pkh_address' : IDL.Func([], [BitcoinAddress], []),
    'get_utxos' : IDL.Func([BitcoinAddress], [GetUtxosResponse], []),
    'send' : IDL.Func([SendRequest], [IDL.Text], []),
    'send_http_post_request_to_get_transaction' : IDL.Func(
        [IDL.Text],
        [IDL.Text],
        [],
      ),
    'transform' : IDL.Func(
        [TransformArgs],
        [CanisterHttpResponsePayload],
        ['query'],
      ),
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
