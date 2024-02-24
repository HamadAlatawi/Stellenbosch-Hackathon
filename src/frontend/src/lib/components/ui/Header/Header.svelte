<script>
    import { Button } from "$lib/components/ui/button";
    import { setMode, resetMode } from "mode-watcher";
    import { Separator } from "$lib/components/ui/separator";
    import * as DropdownMenu from "$lib/components/ui/dropdown-menu";
    import { Sun, Moon } from "radix-icons-svelte";
    import { tweened } from 'svelte/motion';

    let sideNavBar = false;

    const scale = tweened(1);
    const translateX = tweened(0);

    function toggleNavBar() {
        sideNavBar = !sideNavBar;

        // Update the scale and translateX values based on the navbar visibility
        if (sideNavBar) {
            scale.set(0.9);
            translateX.set(-90);
        } else {
            scale.set(1);
            translateX.set(0);
        }

        // Add or remove the class to the body element based on navbar visibility
        document.body.classList.toggle('nav-open', sideNavBar);
    }

    function Entity() {
        sideNavBar = false;
        document.body.classList.toggle('nav-open', sideNavBar);
        scrollIntoView("#donateSection")
    }

    function Transaction() {
        sideNavBar = false;
        document.body.classList.toggle('nav-open', sideNavBar);
        scrollIntoView("#transactionSection")
    }

    function goHome(){
        sideNavBar = false;
        document.body.classList.toggle('nav-open', sideNavBar);
        scrollIntoView("#homeSection")
    }

    function closeNav(){
        sideNavBar = false;
        document.body.classList.toggle('nav-open', sideNavBar);
    }

    function navigateToPageAndSection(){
        sideNavBar = false;
        document.body.classList.toggle('nav-open', sideNavBar);
        scrollIntoView("#impactSection")
    }

    function scrollIntoView(target) {
		const el = document.querySelector(target);
		if (!el) return;
		el.scrollIntoView({
		behavior: 'smooth'
		});
  	}
</script>

<header>
    <!-- Mobile Navigation -->
    <div class="text-black dark:text-white fixed lg:hidden inset-0 z-50 top-0 right-0 h-full w-80svw bg-white dark:bg-[#0C0A09] transform translate-x-full transition-transform duration-300 navbarVisible pointer-events-auto thisIsNav">
        <div class="flex justify-between h-[20%] item-center content-center justify-center max-[500px]:mb-10" style="width: 80%; overflow: hidden">
            <DropdownMenu.Root>
                <DropdownMenu.Trigger asChild let:builder>
                    <Button builders={[builder]} variant="ghost" size="icon" class="h-[4.5rem] w-[5rem] ml-2 min-[500px]:ml-12 min-[600px]:ml-26 sm:ml-32 md:ml-40">
                        <Sun class="h-[2rem] w-[2rem] rotate-0 scale-100 transition-all dark:-rotate-90 dark:scale-0" />
                        <Moon class="absolute h-[2rem] w-[2rem] rotate-90 scale-0 transition-all dark:rotate-0 dark:scale-100" />
                        <span class="sr-only">Toggle theme</span>
                    </Button>
                </DropdownMenu.Trigger>
                <DropdownMenu.Content align="start">
                    <DropdownMenu.Item on:click={() => setMode("light")}>Light</DropdownMenu.Item>
                    <DropdownMenu.Item on:click={() => setMode("dark")}>Dark</DropdownMenu.Item>
                    <DropdownMenu.Item on:click={() => resetMode()}>System</DropdownMenu.Item>
                </DropdownMenu.Content>
            </DropdownMenu.Root>
            <button class="flex justify-center h-full text-6xl text-black dark:text-white cursor-pointer" on:click={closeNav} aria-label="Close Navigation">&times;</button>
        </div>
        <div class="h-[75%]">
            <div class="grid grid-rows-4 grid-flow-col gap-10 justify-center items-center content-center h-full text-4xl font-semibold">
                <a href="#homeSection" on:click|preventDefault={goHome}>Home &#8594;</a>
                <a href="#transactionSection" on:click|preventDefault={Transaction}>Transactions &#8594;</a>
                <a href="#donationSection" on:click|preventDefault={Entity} >Entity &#8594;</a>
                <a href="#impactSection" on:click|preventDefault={navigateToPageAndSection} class="pointer-events-auto text-neutral-500">Learn More</a>
            </div>
        </div>
        <div>
        </div>
    </div>
    <nav class="border-b-stone-900 lg:border-stone-900 border-b-[8px] grid grid-cols-12 lg:grid-cols-12 gap-4 w-full flex-nowrap items-center justify-between bg-white py-4 text-stone-500 hover:text-stone-500 focus:text-stone-700 dark:bg-[#0C0A09] lg:flex-wrap lg:justify-start lg:py-6 data-te-navbar-ref dark:border-white">
        <div class="col-span-8 lg:col-span-3">
            <div class="ml-2 lg:ml-10">
                <a class="text-2xl 2xL:text-4xl font-semibold text-stone-800 dark:text-stone-200" href="#homeSection" on:click|preventDefault={goHome}>Donation Engine</a>
            </div>
        </div>
  
        <div class="hidden lg:flex lg:col-span-6 justify-center items-center text-center">
            <div class="!visible mt-2 hidden items-center lg:mt-0 lg:!flex lg:basis-auto" id="navbarSupportedContent2" data-te-collapse-item>
                <ul class="list-style-none mr-auto flex flex-col pl-0 lg:mt-1 lg:flex-row gap-x-6" data-te-navbar-nav-ref>
                    <li data-te-nav-item-ref>
                        <a class="active text-lg font-semibold disabled:text-black/30 lg:px-2 [&.active]:text-black/90 dark:[&.active]:text-stone-400" aria-current="page" href="#homeSection" on:click={goHome} data-te-nav-link-ref>Home</a>
                    </li>
                    <Separator orientation="vertical" />
                    <li data-te-nav-item-ref>
                      <a class="p-0 text-lg font-semibold text-stone-500 transition duration-200 hover:text-stone-700 hover:ease-in-out focus:text-stone-700 disabled:text-black/30 motion-reduce:transition-none dark:text-stone-200 dark:hover:text-stone-400 dark:focus:text-stone-400 lg:px-2 [&.active]:text-black/90 dark:[&.active]:text-stone-400" href="#transactionSection" on:click|preventDefault={Transaction} data-te-nav-link-ref>Transactions</a>
                    </li>
                    <Separator orientation="vertical" />
                    <li data-te-nav-item-ref>
                        <a class="p-0 text-lg font-semibold text-stone-500 transition duration-200 hover:text-stone-700 hover:ease-in-out focus:text-stone-700 disabled:text-black/30 motion-reduce:transition-none dark:text-stone-200 dark:hover:text-stone-400 dark:focus:text-stone-400 lg:px-2 [&.active]:text-black/90 dark:[&.active]:text-stone-400" href="#donationSection" on:click|preventDefault={Entity} data-te-nav-link-ref>Entity</a>
                    </li>
                    <Separator orientation="vertical" />
                    <li data-te-nav-item-ref>
                        <a class="p-0 text-lg font-semibold text-stone-500 transition duration-200 hover:text-stone-700 hover:ease-in-out focus:text-stone-700 disabled:text-black/30 motion-reduce:transition-none dark:text-stone-200 dark:hover:text-stone-400 dark:focus:text-stone-400 lg:px-2 [&.active]:text-black/90 dark:[&.active]:text-stone-400" href="#impactSection" on:click|preventDefault={navigateToPageAndSection} data-te-nav-link-ref>Learn More</a>
                    </li>
                </ul>
            </div>
        </div>
  
        <div class="hidden lg:flex col-span-3 items-end justify-end mr-5">
          <DropdownMenu.Root>
              <DropdownMenu.Trigger asChild let:builder>
                  <Button builders={[builder]} variant="outline" size="icon">
                      <Sun class="h-[1.2rem] w-[1.2rem] rotate-0 scale-100 transition-all dark:-rotate-90 dark:scale-0" />
                      <Moon class="absolute h-[1.2rem] w-[1.2rem] rotate-90 scale-0 transition-all dark:rotate-0 dark:scale-100" />
                      <span class="sr-only">Toggle theme</span>
                  </Button>
              </DropdownMenu.Trigger>
              <DropdownMenu.Content align="end">
                  <DropdownMenu.Item on:click={() => setMode("light")}>Light</DropdownMenu.Item>
                  <DropdownMenu.Item on:click={() => setMode("dark")}>Dark</DropdownMenu.Item>
                  <DropdownMenu.Item on:click={() => resetMode()}>System</DropdownMenu.Item>
              </DropdownMenu.Content>
          </DropdownMenu.Root>
  
          <Separator orientation="vertical" />
  
          <Button class="mx-5" on:click={Entity}>Donate</Button>
        </div>
  
        <div class="col-span-4 lg:hidden content-end flex justify-end mr-3">
            <button aria-label="Toggle navigation" on:click={toggleNavBar}>
                <div class="w-6 h-1 my-1 bg-stone-900 dark:bg-white"></div>
                <div class="w-6 h-1 my-1 bg-stone-900 dark:bg-white"></div>
                <div class="w-6 h-1 bg-stone-900 dark:bg-white"></div>
            </button>
        </div>
    </nav>
</header>

<style>
    header {
        display: flex;
        justify-content: space-between;
        view-transition-name: header;
    }
</style>
