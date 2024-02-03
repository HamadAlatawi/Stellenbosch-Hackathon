<script lang="ts">
  //   import { Reload, GridViewIcon, TableViewIcon } from "radix-icons-svelte";
  import { Button } from "$lib/components/ui/button";
  import entities from "$lib/data/enitities.json";
  import DonateButton from "$lib/components/ui/donateButton/donateButton.svelte";
  import * as Table from "$lib/components/ui/table";

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

<section class="bg-white p-4 min-h-screen">
  <div class="text-center my-8">
    <h1 class="text-4xl font-bold text-black">Explore Donation Options</h1>
    <div class="flex flex-row justify-between items-center">
      <input
        type="text"
        placeholder="Search entity..."
        bind:value={searchTerm}
        class="p-2 border rounded"
      />
      <div class="button-group">
        <Button
          on:click={() => toggleView("card")}
          class={viewMode === "card"
            ? "bg-blue-500 hover:bg-blue-800 text-white font-bold py-2 px-4 rounded"
            : "bg-gray-700 hover:bg-gray-900 text-white font-bold py-2 px-4 rounded"}
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
            ? "bg-blue-500 hover:bg-blue-800 text-white font-bold py-2 px-4 rounded"
            : "bg-gray-700 hover:bg-gray-900 text-white font-bold py-2 px-4 rounded"}
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
    </div>
  </div>
  {#if viewMode === "card"}
    <div
      class="mt-6 grid grid-cols-1 gap-x-6 gap-y-10 sm:grid-cols-2 lg:grid-cols-4 xl:gap-x-8 mx-5"
    >
      {#each filteredEntities as entity}
        <div
          class="group relative max-w-md mx-auto bg-white rounded-lg shadow-lg overflow-hidden md:max-w-2xl my-10"
        >
          <div
            class="aspect-w-1 aspect-h-1 w-full overflow-hidden rounded-t-lg bg-gray-200 group-hover:opacity-75"
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
                <h3 class="text-base text-gray-900">
                  {entity.name}
                </h3>
                <h4 class="text-base text-gray-900 flex">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    viewBox="0 0 24 24"
                    fill="currentColor"
                    class="w-6 h-6 mx-1"
                  >
                    <path
                      d="M21 6.375c0 2.692-4.03 4.875-9 4.875S3 9.067 3 6.375 7.03 1.5 12 1.5s9 2.183 9 4.875Z"
                    />
                    <path
                      d="M12 12.75c2.685 0 5.19-.586 7.078-1.609a8.283 8.283 0 0 0 1.897-1.384c.016.121.025.244.025.368C21 12.817 16.97 15 12 15s-9-2.183-9-4.875c0-.124.009-.247.025-.368a8.285 8.285 0 0 0 1.897 1.384C6.809 12.164 9.315 12.75 12 12.75Z"
                    />
                    <path
                      d="M12 16.5c2.685 0 5.19-.586 7.078-1.609a8.282 8.282 0 0 0 1.897-1.384c.016.121.025.244.025.368 0 2.692-4.03 4.875-9 4.875s-9-2.183-9-4.875c0-.124.009-.247.025-.368a8.284 8.284 0 0 0 1.897 1.384C6.809 15.914 9.315 16.5 12 16.5Z"
                    />
                    <path
                      d="M12 20.25c2.685 0 5.19-.586 7.078-1.609a8.282 8.282 0 0 0 1.897-1.384c.016.121.025.244.025.368 0 2.692-4.03 4.875-9 4.875s-9-2.183-9-4.875c0-.124.009-.247.025-.368a8.284 8.284 0 0 0 1.897 1.384C6.809 19.664 9.315 20.25 12 20.25Z"
                    />
                  </svg>
                  {entity.raise}
                </h4>
              </div>

              <p class="mt-1 text-sm text-gray-500">
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
    <Table.Root>
      <Table.Header>
        <Table.Row>
          <Table.Head class="w-[100px]"></Table.Head>
          <Table.Head>Name</Table.Head>
          <Table.Head>Story</Table.Head>
          <Table.Head>Amount Raised</Table.Head>
          <Table.Head></Table.Head>
        </Table.Row>
      </Table.Header>
      <Table.Body>
        {#each entities as entity, i (i)}
          <Table.Row>
            <Table.Cell class="text-base text-gray-900">
              <img
                src={entity.image ||
                  "https://www.google.com/url?sa=i&url=https%3A%2F%2Fstock.adobe.com%2Fsearch%3Fk%3Dperson&psig=AOvVaw08AqwGaHwVbtOKCkCxYa38&ust=1707054467295000&source=images&cd=vfe&opi=89978449&ved=0CBMQjRxqFwoTCKjn0Munj4QDFQAAAAAdAAAAABAE"}
                width="512"
                height="512"
                alt={entity.name}
                style="max-height: 60px"
                class="w-full h-full object-cover shadow-lg zoom"
              />
            </Table.Cell>
            <Table.Cell class="text-base text-gray-900"
              >{entity.name}</Table.Cell
            >
            <Table.Cell class="text-base text-gray-900"
              >{entity.story.length > 100
                ? entity.story.substring(0, 80) + "..."
                : entity.story}</Table.Cell
            >
            <Table.Cell class="text-base text-gray-700">
              <div class="flex">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 24 24"
                  fill="currentColor"
                  class="w-6 h-6 mx-1"
                >
                  <path
                    d="M21 6.375c0 2.692-4.03 4.875-9 4.875S3 9.067 3 6.375 7.03 1.5 12 1.5s9 2.183 9 4.875Z"
                  />
                  <path
                    d="M12 12.75c2.685 0 5.19-.586 7.078-1.609a8.283 8.283 0 0 0 1.897-1.384c.016.121.025.244.025.368C21 12.817 16.97 15 12 15s-9-2.183-9-4.875c0-.124.009-.247.025-.368a8.285 8.285 0 0 0 1.897 1.384C6.809 12.164 9.315 12.75 12 12.75Z"
                  />
                  <path
                    d="M12 16.5c2.685 0 5.19-.586 7.078-1.609a8.282 8.282 0 0 0 1.897-1.384c.016.121.025.244.025.368 0 2.692-4.03 4.875-9 4.875s-9-2.183-9-4.875c0-.124.009-.247.025-.368a8.284 8.284 0 0 0 1.897 1.384C6.809 15.914 9.315 16.5 12 16.5Z"
                  />
                  <path
                    d="M12 20.25c2.685 0 5.19-.586 7.078-1.609a8.282 8.282 0 0 0 1.897-1.384c.016.121.025.244.025.368 0 2.692-4.03 4.875-9 4.875s-9-2.183-9-4.875c0-.124.009-.247.025-.368a8.284 8.284 0 0 0 1.897 1.384C6.809 19.664 9.315 20.25 12 20.25Z"
                  />
                </svg>
                {entity.raise}
              </div>
            </Table.Cell>
            <Table.Cell class="text-base text-gray-700 text-right"
              ><DonateButton {entity} /></Table.Cell
            >
          </Table.Row>
        {/each}
      </Table.Body>
    </Table.Root>
  {/if}
</section>

<style>
  .zoom {
    transition: 0.3s all ease-in-out;
  }
  .zoom:hover {
    transform: scale(1.1);
  }
</style>
