import type { Principal } from '@dfinity/principal';
import type { ActorMethod } from '@dfinity/agent';
import type { IDL } from '@dfinity/candid';

export interface BasicBitcoin {
  'generateUUID' : ActorMethod<[], string>,
  'get_balance' : ActorMethod<[BitcoinAddress], Satoshi__1>,
  'get_current_fee_percentiles' : ActorMethod<[], BigUint64Array | bigint[]>,
  'get_p2pkh_address' : ActorMethod<[], BitcoinAddress>,
  'get_utxos' : ActorMethod<[BitcoinAddress], GetUtxosResponse>,
  'send' : ActorMethod<[SendRequest], string>,
  'send_http_post_request_to_get_transaction' : ActorMethod<[string], string>,
  'transform' : ActorMethod<[TransformArgs], CanisterHttpResponsePayload>,
}
export type BitcoinAddress = string;
export type BlockHash = Uint8Array | number[];
export interface CanisterHttpResponsePayload {
  'status' : bigint,
  'body' : Uint8Array | number[],
  'headers' : Array<HttpHeader>,
}
export interface GetUtxosResponse {
  'next_page' : [] | [Page],
  'tip_height' : number,
  'tip_block_hash' : BlockHash,
  'utxos' : Array<Utxo>,
}
export interface HttpHeader { 'value' : string, 'name' : string }
export interface HttpResponsePayload {
  'status' : bigint,
  'body' : Uint8Array | number[],
  'headers' : Array<HttpHeader>,
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
export interface TransformArgs {
  'context' : Uint8Array | number[],
  'response' : HttpResponsePayload,
}
export interface Utxo {
  'height' : number,
  'value' : Satoshi,
  'outpoint' : OutPoint,
}
export interface _SERVICE extends BasicBitcoin {}
export declare const idlFactory: IDL.InterfaceFactory;
