import { writable } from 'svelte/store';

export const sortStore = writable('ID ASC');

export const sortStoreTable = writable('');