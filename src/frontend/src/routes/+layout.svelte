<script>
  import "../app.css";
  import { goto } from '$app/navigation';
  import { Button } from "$lib/components/ui/button";
  import * as DropdownMenu from "$lib/components/ui/dropdown-menu";
  import { Sun, Moon } from "radix-icons-svelte";
  import { ModeWatcher, setMode, resetMode } from "mode-watcher";

  const frontendCanisterId = import.meta.env.VITE_FRONTEND_CANISTER_ID;

  function Entity() {
		goto('/entity?canisterId=' + frontendCanisterId);
	}

  function Transaction() {
		goto('/transaction?canisterId=' + frontendCanisterId);
	}

  function goHome(){
    goto('/?canisterId=' + frontendCanisterId)
  }
</script>

  <nav class="border-b-slate-900 bg-white  lg:border-slate-900 lg:border-b-4
  flex w-full flex-nowrap items-center justify-between bg-[#FBFBFB] py-2 text-neutral-500
   hover:text-neutral-700 focus:text-neutral-700 dark:bg-neutral-600 lg:flex-wrap lg:justify-start lg:py-4
  data-te-navbar-ref">
    <div class="flex w-full flex-wrap items-center justify-between px-3">
      <div class="ml-2">
        <a class="text-xl text-neutral-800 dark:text-neutral-200" href="#"
          >Navbar</a
        >
      </div>
      <!-- Hamburger button for mobile view -->
      <button
        class="block border-0 bg-transparent px-2 text-neutral-500 hover:no-underline hover:shadow-none focus:no-underline focus:shadow-none focus:outline-none focus:ring-0 dark:text-neutral-200 lg:hidden"
        type="button"
        data-te-collapse-init
        data-te-target="#navbarSupportedContent2"
        aria-controls="navbarSupportedContent2"
        aria-expanded="false"
        aria-label="Toggle navigation">
        <!-- Hamburger icon -->
        <span class="[&>svg]:w-7">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="currentColor"
            class="h-7 w-7">
            <path
              fill-rule="evenodd"
              d="M3 6.75A.75.75 0 013.75 6h16.5a.75.75 0 010 1.5H3.75A.75.75 0 013 6.75zM3 12a.75.75 0 01.75-.75h16.5a.75.75 0 010 1.5H3.75A.75.75 0 013 12zm0 5.25a.75.75 0 01.75-.75h16.5a.75.75 0 010 1.5H3.75a.75.75 0 01-.75-.75z"
              clip-rule="evenodd" />
          </svg>
        </span>
      </button>
  
      <!-- Collapsible navbar container -->
      <div
        class="!visible mt-2 hidden flex-grow basis-[100%] items-center lg:mt-0 lg:!flex lg:basis-auto"
        id="navbarSupportedContent2"
        data-te-collapse-item>
        <!-- Left links -->
        <ul
          class="list-style-none mr-auto flex flex-col pl-0 lg:mt-1 lg:flex-row"
          data-te-navbar-nav-ref>
          <!-- Home link -->
          <li
            class="my-4 pl-2 lg:my-0 lg:pl-2 lg:pr-1"
            data-te-nav-item-ref>
            <a
              class="active disabled:text-black/30 lg:px-2 [&.active]:text-black/90 dark:[&.active]:text-neutral-400"
              aria-current="page"
              href="/?canisterId={frontendCanisterId}"
              on:click={goHome}
              data-te-nav-link-ref
              >Home</a
            >
          </li>
          <!-- Features link -->
          <li
            class="mb-4 pl-2 lg:mb-0 lg:pl-0 lg:pr-1"
            data-te-nav-item-ref>
            <a
              class="p-0 text-neutral-500 transition duration-200 hover:text-neutral-700 hover:ease-in-out focus:text-neutral-700 disabled:text-black/30 motion-reduce:transition-none dark:text-neutral-200 dark:hover:text-neutral-400 dark:focus:text-neutral-400 lg:px-2 [&.active]:text-black/90 dark:[&.active]:text-neutral-400"
              href="/entity?canisterId={frontendCanisterId}"
              on:click={Entity}
              data-te-nav-link-ref
              >Entity</a
            >
          </li>
          <li
          class="mb-4 pl-2 lg:mb-0 lg:pl-0 lg:pr-1"
          data-te-nav-item-ref>
          <a
            class="p-0 text-neutral-500 transition duration-200 hover:text-neutral-700 hover:ease-in-out focus:text-neutral-700 disabled:text-black/30 motion-reduce:transition-none dark:text-neutral-200 dark:hover:text-neutral-400 dark:focus:text-neutral-400 lg:px-2 [&.active]:text-black/90 dark:[&.active]:text-neutral-400"
            href="/transaction?canisterId={frontendCanisterId}"
            on:click={Transaction}
            data-te-nav-link-ref
            >Transaction</a
          >
        </li>
          <li
          class="mb-4 pl-2 lg:mb-0 lg:pl-0 lg:pr-1"
          data-te-nav-item-ref>
          <DropdownMenu.Root>
            <DropdownMenu.Trigger asChild let:builder>
              <Button builders={[builder]} variant="outline" size="icon">
                <Sun
                  class="h-[1.2rem] w-[1.2rem] rotate-0 scale-100 transition-all dark:-rotate-90 dark:scale-0"
                />
                <Moon
                  class="absolute h-[1.2rem] w-[1.2rem] rotate-90 scale-0 transition-all dark:rotate-0 dark:scale-100"
                />
                <span class="sr-only">Toggle theme</span>
              </Button>
            </DropdownMenu.Trigger>
            <DropdownMenu.Content align="end">
              <DropdownMenu.Item on:click={() => setMode("light")}
                >Light</DropdownMenu.Item
              >
              <DropdownMenu.Item on:click={() => setMode("dark")}>Dark</DropdownMenu.Item>
              <DropdownMenu.Item on:click={() => resetMode()}>System</DropdownMenu.Item>
            </DropdownMenu.Content>
          </DropdownMenu.Root>
        </li>
        </ul>
      </div>
    </div>
  </nav>

<ModeWatcher />
<slot />