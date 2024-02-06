import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';

export interface BasicBitcoin {
  'get_balance' : ActorMethod<[BitcoinAddress__1], Satoshi__1>,
  'get_current_fee_percentiles' : ActorMethod<[], BigUint64Array | bigint[]>,
  'get_p2pkh_address' : ActorMethod<[], BitcoinAddress__1>,
  'get_utxos' : ActorMethod<[BitcoinAddress__1], GetUtxosResponse>,
  'processTransaction' : ActorMethod<[string, Network], TransactionDetails>,
  'send' : ActorMethod<[SendRequest], string>,
}
export type BitcoinAddress = string;
export type BitcoinAddress__1 = string;
export type BlockHash = Uint8Array | number[];
export interface GetUtxosResponse {
  'next_page' : [] | [Page],
  'tip_height' : number,
  'tip_block_hash' : BlockHash,
  'utxos' : Array<Utxo>,
}
export type MillisatoshiPerVByte = bigint;
export type Network = { 'mainnet' : null } |
  { 'regtest' : null } |
  { 'testnet' : null };
export interface OutPoint { 'txid' : Uint8Array | number[], 'vout' : number }
export type Page = Uint8Array | number[];
export type Satoshi = bigint;
export type Satoshi__1 = bigint;
export interface SendRequest {
  'destination_address' : string,
  'amount_in_satoshi' : Satoshi,
}
export interface TransactionDetails {
  'confirmation' : bigint,
  'recipientAddress' : BitcoinAddress,
  'amount' : Satoshi,
  'senderAddress' : BitcoinAddress,
}
export interface Utxo {
  'height' : number,
  'value' : Satoshi,
  'outpoint' : OutPoint,
}
export interface _SERVICE extends BasicBitcoin {}
