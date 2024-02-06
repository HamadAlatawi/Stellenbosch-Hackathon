<script lang="ts">
  //   import { Reload, GridViewIcon, TableViewIcon } from "radix-icons-svelte";
  import { Button } from "$lib/components/ui/button";
  import entities from "$lib/data/enitities.json";
  import DonateButton from "$lib/components/ui/donateButton/donateButton.svelte";
  import * as Table from "$lib/components/ui/table";
  import { Input } from "$lib/components/ui/input";

  let innerWidth: any;

  let searchTerm = "";
  let viewMode = "card"; // "card" or "table"

  $: filteredEntities =
    searchTerm === ""
      ? entities
      : entities.filter((entity) =>
          entity.name.toLowerCase().includes(searchTerm.toLowerCase())
        );

  function toggleView(mode: string) {
    viewMode = mode;
  }
</script>

<link
  rel="stylesheet"
  href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css"
/>

<svelte:head>
  <title>Entities - Donation Engine</title>
  <meta
    name="description"
    content="Explore and contribute to various donation options."
  />
</svelte:head>
<svelte:window bind:innerWidth />

<section class="grid grid-cols-12 flex my-6 md:my-12 lg:my-20 text-center">
  <div class="hidden lg:flex col-span-1"></div>
  <div class="col-span-12 lg:col-span-10">
    <h1 class="p-1 text-3xl md:text-5xl lg:text-6xl font-semibold">
      Explore Donation Options
    </h1>
  </div>
  <div class="hidden lg:flex col-span-1"></div>
</section>
<section class="grid grid-cols-12 flex mt-10">
  <div class="col-span-1"></div>
  <div
    class="col-span-10 mb-10 md:mb-0 md:col-span-5 flex items-center space-x-2 md:max-w-sm"
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
  <div class="col-span-10 md:col-span-5 flex md:justify-end justify-center">
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
  <div class="col-span-1"></div>
</section>
<section class="grid grid-cols-12 flex mt-10">
  <div class="col-span-1"></div>
  <div class="col-span-10 flex justify-end">
    {#if viewMode === "card"}
      <div
        class="mt-6 grid grid-cols-1 gap-x-6 sm:grid-cols-2 lg:grid-cols-4 xl:gap-x-8 mx-5"
      >
        {#each filteredEntities as entity}
          <div
            class="group relative max-w-md mx-auto bg-white rounded-lg shadow-lg overflow-hidden md:max-w-2xl my-10"
          >
            <div
              class="aspect-w-1 aspect-h-1 w-full overflow-hidden rounded-t-lg bg-stone-200 group-hover:opacity-75"
            >
              <img
                src={entity.image ||
                  "https://www.google.com/url?sa=i&url=https%3A%2F%2Fstock.adobe.com%2Fsearch%3Fk%3Dperson&psig=AOvVaw08AqwGaHwVbtOKCkCxYa38&ust=1707054467295000&source=images&cd=vfe&opi=89978449&ved=0CBMQjRxqFwoTCKjn0Munj4QDFQAAAAAdAAAAABAE"}
                alt={entity.name}
                class="h-full w-full object-cover object-center zoom"
                style="max-height: 30vh"
              />
            </div>
            <div class="mt-4 flex justify-between p-4 flex-col">
              <div class="mb-3">
                <div class="flex justify-between mb-3">
                  <h3 class="text-base text-stone-900">
                    {entity.name}
                  </h3>
                  <h4 class="text-base text-stone-900 flex">
                    <svg
                      xmlns="http://www.w3.org/2000/svg"
                      viewBox="0 0 320 512"
                      class="w-6 h-6 mx-1"
                      > <path
                        d="M48 32C48 14.3 62.3 0 80 0s32 14.3 32 32V64h32V32c0-17.7 14.3-32 32-32s32 14.3 32 32V64c0 1.5-.1 3.1-.3 4.5C254.1 82.2 288 125.1 288 176c0 24.2-7.7 46.6-20.7 64.9c31.7 19.8 52.7 55 52.7 95.1c0 61.9-50.1 112-112 112v32c0 17.7-14.3 32-32 32s-32-14.3-32-32V448H112v32c0 17.7-14.3 32-32 32s-32-14.3-32-32V448H41.7C18.7 448 0 429.3 0 406.3V288 265.7 224 101.6C0 80.8 16.8 64 37.6 64H48V32zM64 224H176c26.5 0 48-21.5 48-48s-21.5-48-48-48H64v96zm112 64H64v96H208c26.5 0 48-21.5 48-48s-21.5-48-48-48H176z"
                      /></svg
                    >
                    {entity.raise}
                  </h4>
                </div>

                <p class="mt-1 text-sm text-stone-500">
                  {entity.story.length > 100
                    ? entity.story.substring(0, 147) + "..."
                    : entity.story}
                </p>
              </div>
              <DonateButton {entity} />
            </div>
          </div>
        {/each}
      </div>
    {:else}
      <Table.Root class="my-10">
        <Table.Header>
          <Table.Row class="max-[400px]:text-xs max-[500px]:text-md">
            <Table.Head class="w-[100px]"></Table.Head>
            <Table.Head>Name</Table.Head>
            {#if innerWidth > 800}
              <Table.Head>Story</Table.Head>
            {/if}

            <Table.Head>Amount Raised</Table.Head>
            <Table.Head></Table.Head>
          </Table.Row>
        </Table.Header>
        <Table.Body>
          {#each entities as entity, i (i)}
            <Table.Row>
              <Table.Cell class="text-base ">
                <div class="m-1 border-r-4 pr-3">
                  <img
                    src={entity.image ||
                      "https://www.google.com/url?sa=i&url=https%3A%2F%2Fstock.adobe.com%2Fsearch%3Fk%3Dperson&psig=AOvVaw08AqwGaHwVbtOKCkCxYa38&ust=1707054467295000&source=images&cd=vfe&opi=89978449&ved=0CBMQjRxqFwoTCKjn0Munj4QDFQAAAAAdAAAAABAE"}
                    width="512"
                    height="512"
                    alt={entity.name}
                    style="max-height: 60px;"
                    class="w-full h-full object-cover shadow-lg zoom rounded-full"
                  />
                </div>
              </Table.Cell>
              <Table.Cell class="text-base"
                >{entity.name}</Table.Cell
              >
              {#if innerWidth > 800}
                <Table.Cell class="text-base"
                  >{entity.story.length > 100
                    ? entity.story.substring(0, 80) + "..."
                    : entity.story}</Table.Cell
                >
              {/if}
              <Table.Cell class="text-base">
                <div class="flex dark:bg-white dark:p-1 dark:rounded dark:text-black">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 320 512"
                    class="w-6 h-6 mr-1"
                    > <path
                      d="M48 32C48 14.3 62.3 0 80 0s32 14.3 32 32V64h32V32c0-17.7 14.3-32 32-32s32 14.3 32 32V64c0 1.5-.1 3.1-.3 4.5C254.1 82.2 288 125.1 288 176c0 24.2-7.7 46.6-20.7 64.9c31.7 19.8 52.7 55 52.7 95.1c0 61.9-50.1 112-112 112v32c0 17.7-14.3 32-32 32s-32-14.3-32-32V448H112v32c0 17.7-14.3 32-32 32s-32-14.3-32-32V448H41.7C18.7 448 0 429.3 0 406.3V288 265.7 224 101.6C0 80.8 16.8 64 37.6 64H48V32zM64 224H176c26.5 0 48-21.5 48-48s-21.5-48-48-48H64v96zm112 64H64v96H208c26.5 0 48-21.5 48-48s-21.5-48-48-48H176z"
                    /></svg
                  >
                  {entity.raise}
                </div>
              </Table.Cell>
              <Table.Cell class="text-base text-right"
                ><DonateButton {entity} /></Table.Cell
              >
            </Table.Row>
          {/each}
        </Table.Body>
      </Table.Root>
    {/if}
  </div>
  <div class="col-span-1"></div>
</section>

<!-- <section class=" p-4 min-h-screen">
  <div class="text-center my-8">
    <h1 class="text-4xl font-bold">Explore Donation Options</h1>
    
  </div>

</section> -->

<style>
  .zoom {
    transition: 0.3s all ease-in-out;
  }
  .zoom:hover {
    transform: scale(1.1);
  }
</style>
