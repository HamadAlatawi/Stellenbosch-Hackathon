<script lang="ts">
    import { Button } from "$lib/components/ui/button";
    import { entities } from "$lib/data/+page.svelte";
    import DonateButton from "$lib/components/ui/donateButton/donateButton.svelte";
    import * as Table from "$lib/components/ui/table";
    import { Input } from "$lib/components/ui/input";
    import { mode } from "mode-watcher";
    import * as Pagination from "$lib/components/ui/pagination";

    let svgMode = $mode === "light" ? "white" : "black";
    
    $: {
        svgMode = $mode === "light" ? "black" : "white";
    }

  
    let innerWidth: any;
  
    let searchTerm = "";
    let viewMode = "card";
  
    $: filteredEntities =
      searchTerm === ""
        ? entities
        : entities.filter((entity) =>
            entity.name.toLowerCase().includes(searchTerm.toLowerCase())
          );
  
    function toggleView(mode: string) {
      viewMode = mode;
    }

    let currentPage = 1;
    const entitiesPerPage = 8;


    $: paginatedEntities = filteredEntities.slice(
        (currentPage - 1) * entitiesPerPage,
        currentPage * entitiesPerPage
    );

    async function defaultPageChange(event : number){
        currentPage = event;
    };
  </script>
  
  <svelte:head>
    <title>Entities - Donation Engine</title>
    <meta
      name="description"
      content="Explore and contribute to various donation options."
    />
  </svelte:head>
  <svelte:window bind:innerWidth />
  
  <main class="min-h-fit ">
      <section class="grid grid-cols-12 mt-10">
        <div class="col-span-1 md:hidden"></div>
        <div
          class="col-span-10 mb-10 md:mb-0 md:col-span-6 flex items-center space-x-2 md:max-w-sm"
        >
          <form class="flex w-full md:w-full items-center space-x-2">
            <Input
              type="text"
              placeholder="Search for Entity"
              bind:value={searchTerm}
            />
          </form>
        </div>
        <div class="col-span-1 md:hidden"></div>
        <div class="col-span-1 md:hidden"></div>
        <div class="col-span-10 md:col-span-6 flex md:justify-end justify-center">
          <Button
            on:click={() => toggleView("card")}
            class={viewMode === "card"
              ? "dark:bg-stone-600 bg-stone-800 hover:bg-stone-700 text-white font-bold py-2 px-4 rounded-none rounded-tl-md rounded-bl-md w-full md:w-auto"
              : "dark:bg-stone-800 bg-stone-400 hover:bg-stone-900 text-white font-bold py-2 px-4 rounded-none rounded-tl-md rounded-bl-md w-full md:w-auto"}
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="currentColor"
              class="w-6 h-6"
            >
              <path
                fill-rule="evenodd"
                d="M3 6a3 3 0 0 1 3-3h2.25a3 3 0 0 1 3 3v2.25a3 3 0 0 1-3 3H6a3 3 0 0 1-3-3V6Zm9.75 0a3 3 0 0 1 3-3H18a3 3 0 0 1 3 3v2.25a3 3 0 0 1-3 3h-2.25a3 3 0 0 1-3-3V6ZM3 15.75a3 3 0 0 1 3-3h2.25a3 3 0 0 1 3 3V18a3 3 0 0 1-3 3H6a3 3 0 0 1-3-3v-2.25Zm9.75 0a3 3 0 0 1 3-3H18a3 3 0 0 1 3 3V18a3 3 0 0 1-3 3h-2.25a3 3 0 0 1-3-3v-2.25Z"
                clip-rule="evenodd"
              />
            </svg>
          </Button>
          <Button
            on:click={() => toggleView("table")}
            class={viewMode === "table"
              ? "dark:bg-stone-600 bg-stone-800 hover:bg-stone-700 text-white font-bold py-2 px-4 rounded-none rounded-tr-md rounded-br-md w-full md:w-auto"
              : "dark:bg-stone-800 bg-stone-400 hover:bg-stone-900 text-white font-bold py-2 px-4 rounded-none rounded-tr-md rounded-br-md w-full md:w-auto"}
          >
            <svg
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="currentColor"
              class="w-6 h-6"
            >
              <path
                fill-rule="evenodd"
                d="M1.5 5.625c0-1.036.84-1.875 1.875-1.875h17.25c1.035 0 1.875.84 1.875 1.875v12.75c0 1.035-.84 1.875-1.875 1.875H3.375A1.875 1.875 0 0 1 1.5 18.375V5.625ZM21 9.375A.375.375 0 0 0 20.625 9h-7.5a.375.375 0 0 0-.375.375v1.5c0 .207.168.375.375.375h7.5a.375.375 0 0 0 .375-.375v-1.5Zm0 3.75a.375.375 0 0 0-.375-.375h-7.5a.375.375 0 0 0-.375.375v1.5c0 .207.168.375.375.375h7.5a.375.375 0 0 0 .375-.375v-1.5Zm0 3.75a.375.375 0 0 0-.375-.375h-7.5a.375.375 0 0 0-.375.375v1.5c0 .207.168.375.375.375h7.5a.375.375 0 0 0 .375-.375v-1.5ZM10.875 18.75a.375.375 0 0 0 .375-.375v-1.5a.375.375 0 0 0-.375-.375h-7.5a.375.375 0 0 0-.375.375v1.5c0 .207.168.375.375.375h7.5ZM3.375 15h7.5a.375.375 0 0 0 .375-.375v-1.5a.375.375 0 0 0-.375-.375h-7.5a.375.375 0 0 0-.375.375v1.5c0 .207.168.375.375.375Zm0-3.75h7.5a.375.375 0 0 0 .375-.375v-1.5A.375.375 0 0 0 10.875 9h-7.5A.375.375 0 0 0 3 9.375v1.5c0 .207.168.375.375.375Z"
                clip-rule="evenodd"
              />
            </svg>
          </Button>
        </div>
        <div class="col-span-1 md:hidden"></div>
      </section>
      <section class="grid grid-cols-12 mt-10">
        <div class="col-span-12 flex">
          {#if viewMode === "card"}
            <div
              class="mt-6 grid grid-cols-1 gap-x-6 lg:grid-cols-2 xl:grid-cols-4 xl:gap-x-8 mx-5"
            >
            {#each paginatedEntities as entity}
            <div
              class="group relative max-w-md mx-auto bg-stone-900 dark:bg-stone-800 rounded-xl shadow-lg overflow-hidden md:max-w-2xl my-10 border-4 border-stone-900 dark:border-0 p-4"
            >
            <div class="px-2 mt-4 flex justify-between flex-col">
              <div class="mb-3">
                <div class="flex justify-between mb-2">
                  <h3 class="text-stone-100 font-semibold">
                    {entity.name}
                  </h3>
                  <h4 class="text-stone-100 flex font-semibold">
                    <svg width="22" height="22" viewBox="0 0 128 128" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M69.4498 101.067C96.1161 101.066 96.1191 63.7353 69.4519 63.7313M69.4498 101.067L37.4594 101.065M69.4498 101.067L69.457 111.734M48.1204 63.7342L69.4572 63.7304C96.1244 63.7344 96.1265 26.3988 69.455 26.401L37.4541 26.4005M69.4497 26.4019L69.4531 15.7326M48.114 111.734L48.1153 15.7311" stroke="white" stroke-width="8" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                  {entity.raise}
                </h4>
                </div>
              </div>
            </div>
              <div
                class="aspect-w-1 aspect-h-1 w-full overflow-hidden rounded-t-lg bg-stone-200 group-hover:opacity-75"
              >
                <img
                  src={entity.image}
                  alt={entity.name}
                  class="h-full w-full object-cover object-top transition-transform duration-300 ease-in-out transform hover:scale-110"
                  style="max-height: 40vh"
                />
              </div>
              <div class="mt-4 flex justify-between px-2 py-4 flex-col">
                <div class="mb-3">
                  <p class="mt-1 text-sm text-stone-100 font-medium">
                    {entity.story.length > 100
                      ? entity.story.substring(0, 147) + "..."
                      : entity.story}
                  </p>
                </div>
                <DonateButton {entity} {viewMode} />
              </div>
            </div>
          {/each}
            </div>
          {:else}
            <Table.Root class="my-10">
              <Table.Header>
                <Table.Row class="max-[400px]:text-xs max-[500px]:text-md">
                    {#if innerWidth > 800}
                  <Table.Head class="w-[100px]"></Table.Head>
                  {/if}
                  <Table.Head>Name</Table.Head>
                  {#if innerWidth > 800}
                    <Table.Head>Story</Table.Head>
                  {/if}
                  <Table.Head>Amount Raised</Table.Head>
                  <Table.Head></Table.Head>
                </Table.Row>
              </Table.Header>
              <Table.Body>
                {#each paginatedEntities as entity, i (i)}
                  <Table.Row>
                    {#if innerWidth > 800}
                    <Table.Cell class="max-[400px]:text-xs max-[500px]:text-md">
                      <div class="m-1 pr-3">
                        <img
                          src={entity.image}
                          width="512"
                          height="512"
                          alt={entity.name}
                          style="max-height: 60px;"
                          class="w-10 h-10 object-cover shadow-lg transition-transform duration-300 ease-in-out transform hover:scale-110 rounded-full"
                        />
                      </div>
                    </Table.Cell>
                    {/if}
                    <Table.Cell class="max-[400px]:text-xs max-[500px]:text-md"
                      >{entity.name}</Table.Cell
                    >
                    {#if innerWidth > 800}
                      <Table.Cell class="max-[400px]:text-xs max-[500px]:text-md"
                        >{entity.story.length > 100
                          ? entity.story.substring(0, 80) + "..."
                          : entity.story}</Table.Cell
                      >
                    {/if}
                    <Table.Cell class="max-[400px]:text-xs max-[500px]:text-md">
                      <div class="flex dark:text-white">
                        <svg width="22" height="22" viewBox="0 0 128 128" fill="none" xmlns="http://www.w3.org/2000/svg">
							<path d="M69.4498 101.067C96.1161 101.066 96.1191 63.7353 69.4519 63.7313M69.4498 101.067L37.4594 101.065M69.4498 101.067L69.457 111.734M48.1204 63.7342L69.4572 63.7304C96.1244 63.7344 96.1265 26.3988 69.455 26.401L37.4541 26.4005M69.4497 26.4019L69.4531 15.7326M48.114 111.734L48.1153 15.7311" stroke="{svgMode}" stroke-width="8" stroke-linecap="round" stroke-linejoin="round"/>
						</svg>
                        {entity.raise}
                      </div>
                    </Table.Cell>
                    <Table.Cell class="max-[400px]:text-xs max-[500px]:text-md"
                      ><DonateButton {entity} {viewMode} /></Table.Cell
                    >
                  </Table.Row>
                {/each}
              </Table.Body>
            </Table.Root>
          {/if}
        </div>
        <div class="col-span-12 flex justify-center mt-5">
            <Pagination.Root count={20} perPage={8} let:pages currentPage={currentPage} onPageChange={defaultPageChange}>
                <Pagination.Content>
                  <Pagination.Item>
                    <Pagination.PrevButton />
                  </Pagination.Item>
                  {#each pages as page (page.key)}
                    {#if page.type === "ellipsis"}
                      <Pagination.Item>
                        <Pagination.Ellipsis />
                      </Pagination.Item>
                    {:else}
                      <Pagination.Item isVisible={currentPage == page.value}>
                        <Pagination.Link {page} isActive={currentPage == page.value}>
                          {page.value}
                        </Pagination.Link>
                      </Pagination.Item>
                    {/if}
                  {/each}
                  <Pagination.Item>
                    <Pagination.NextButton />
                  </Pagination.Item>
                </Pagination.Content>
              </Pagination.Root>
        </div>
      </section>
  </main>