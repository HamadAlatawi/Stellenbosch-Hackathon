import { createActor as createActorBackend } from '../../../../declarations/backend';
import { createActor as createActorBackendTransaction } from '../../../../declarations/backendTransactionStorage';
import { createActor as createActorBackendSorting } from '../../../../declarations/backendTransactionSorting';

const canisterIdBackEnd = import.meta.env.VITE_BACKEND_CANISTER_ID;
const canisterIdBackEndTransactionStorage = import.meta.env.VITE_BACKENDTRANSACTIONSTORAGE_CANISTER_ID;
const canisterIdBackEndTransactionSorting = import.meta.env.VITE_BACKENDTRANSACTIONSORTING_CANISTER_ID;
const frontendCanister = import.meta.env.VITE_FRONTEND_CANISTER_ID;
const host = import.meta.env.VITE_HOST;
const actorBackEnd = createActorBackend(canisterIdBackEnd, { agentOptions: { host } });
const actorBackEndTransaction = createActorBackendTransaction(canisterIdBackEndTransactionStorage, { agentOptions: { host } });
const actorSorting = createActorBackendSorting(canisterIdBackEndTransactionSorting, { agentOptions: { host } });

export {actorBackEnd, actorBackEndTransaction, actorSorting, frontendCanister};