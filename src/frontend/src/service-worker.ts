/// <reference types="@sveltejs/kit" />
/// <reference lib="webworker" />

declare let self : ServiceWorkerGlobalScope

import { build, files, version } from '$service-worker'

const CACHE = `cache-${version}`
const ASSETS = [...build, ...files]


//Cache static files if the version is the same, so that users don't have to put load on the server each time.
self.addEventListener('install', (event) =>{
    async function addFilesToCache(){
        const cache = await caches.open(CACHE)
        await cache.addAll(ASSETS)
    }

    event.waitUntil(addFilesToCache())
})