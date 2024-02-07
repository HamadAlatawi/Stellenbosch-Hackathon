<script lang="ts">
  import "../app.css";
  import { ModeWatcher, mode } from "mode-watcher";
  import { onNavigate } from '$app/navigation';
  import Header from "$lib/components/ui/Header/Header.svelte";
  import { TwitterLogo } from "radix-icons-svelte" 
  import { GithubLogo } from "radix-icons-svelte"
  import { LinkedinLogo } from "radix-icons-svelte"


    //Svelte Transition Directory from page to page. Except the Header
    onNavigate((navigation) => {
      if (!(document as any).startViewTransition) return;
      return new Promise((resolve) => {
        (document as any).startViewTransition(async () => {
          resolve();
          await navigation.complete;
        });
      });
    });

    //Svelte Reactive variable to keep watch for the light/dark mode for CSS selection.
    $: {
        if (typeof document !== 'undefined') {
            document.body.dataset.theme = $mode;
        }
    }
</script>

<Header />

<ModeWatcher defaultMode="light" />
<slot />

<div class="grid grid-cols-12 gap-0 text-white dark:text-black bg-stone-900 dark:bg-white pt-20 pb-2">
  <div class="col-span-12 lg:col-span-6 place-items-center px-8 md:px-16">
    <h3 class="text-3xl font-bold mb-8">Donation Engine</h3>
    <p class="text-xl">Our vision is to provide convenience by donating to entities using cryptocurrencies.</p>
    <div class="mt-12 flex mb-10">
      <div class="w-16 h-16 bg-white dark:bg-black rounded-full md:mr-7 flex justify-center items-center mr-3">
        <TwitterLogo class="w-8 h-8 text-stone-700 dark:text-white" />
      </div>
      <div class="w-16 h-16 bg-white dark:bg-black rounded-full md:mr-7 flex justify-center items-center mr-3">
        <GithubLogo class="w-8 h-8 text-stone-700 dark:text-white" />
      </div>
      <div class="w-16 h-16 bg-white dark:bg-black rounded-full md:mr-7 flex justify-center items-center">
        <LinkedinLogo class="w-8 h-8 text-stone-700 dark:text-white" />
      </div>
    </div>
  </div>
  <div class="col-span-12">
    <hr>
    <div class="grid grid-cols-12 mt-2 text-white dark:text-black font-semibold text-xs lg:text-xl">
      <div class="col-span-8 lg:px-16">
        <p>©2024 Donation Engine. Open Sourced</p>
      </div>
      <div class="col-span-2">
        <p>Privacy & Policy</p>
      </div>
      <div class="col-span-2">
        <p>Terms & Conditions</p>
      </div>
    </div>
  </div>
</div>