import { createActor as createActorBackendSorting } from '../../../../declarations/backendSorting';
import { createActor as createActorBackend } from '../../../../declarations/backend';
import { createActor as createActorBackendTransaction } from '../../../../declarations/backendTransaction';


const canisterIdBackEnd = import.meta.env.VITE_BACKEND_CANISTER_ID;
const canisterIdBackEndTransaction = import.meta.env.VITE_BACKENDTRANSACTION_CANISTER_ID
const canisterIdBackEndSorting = import.meta.env.VITE_BACKENDSORTING_CANISTER_ID;
const frontendCanister = import.meta.env.VITE_FRONTEND_CANISTER_ID
const host = import.meta.env.VITE_HOST;
const actorBackEnd = createActorBackend(canisterIdBackEnd, { agentOptions: { host } });
const actorBackEndTransaction = createActorBackendTransaction(canisterIdBackEndTransaction, { agentOptions: { host } });
const actorSorting = createActorBackendSorting(canisterIdBackEndSorting, { agentOptions: { host } });

export {actorBackEnd, actorBackEndTransaction, actorSorting, frontendCanister}
