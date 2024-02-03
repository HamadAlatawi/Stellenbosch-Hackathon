<script lang="ts">
  import "../app.css";
  import { ModeWatcher, mode } from "mode-watcher";
  import { onNavigate } from '$app/navigation';
  import Header from "$lib/components/ui/Header/Header.svelte";
  import Footer from "$lib/components/ui/footer/footer.svelte";


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

<ModeWatcher />

<slot />

<Footer />
