<script lang="ts">
    import { onMount } from 'svelte';
    import { Button } from "$lib/components/ui/button";
    import * as Table from "$lib/components/ui/table";
    import * as Pagination from "$lib/components/ui/pagination";
    import Skeleton from '$lib/components/ui/skeleton/skeleton.svelte';
    import * as Drawer from "$lib/components/ui/drawer";
    import { Input } from "$lib/components/ui/input";
    import * as DropdownMenu from "$lib/components/ui/dropdown-menu";
    import { createActor as createActorBackendTransaction } from '../../../../declarations/backendTransaction';


    let showSkeleton = true;
    let innerWidth : any;

    let position = "";
    
    let invoiceList: any[] = [];

    onMount(async () => {
        try {
			// Canister IDs are automatically expanded to .env config - see vite.config.ts
			const canisterId = import.meta.env.VITE_BACKENDTRANSACTION_CANISTER_ID;

			// We pass the host instead of using a proxy to support NodeJS >= v17 (ViteJS issue: https://github.com/vitejs/vite/issues/4794)
			const host = import.meta.env.VITE_HOST;

			// Create an actor to interact with the IC for a particular canister ID
			const actor = createActorBackendTransaction(canisterId, { agentOptions: { host } });

            invoiceList = await actor.getAllTransactionTypes();
            showSkeleton = false;
			// Call the IC
		} catch (err: unknown) {
			console.error(err);
		};
    });
</script>

<svelte:head>
	<title>Transaction - Donation Engine</title>
	<meta name="description" content="View Donation Engine" />
</svelte:head>

<svelte:window bind:innerWidth />

<section class="grid grid-cols-12 flex my-6 md:my-12 lg:my-20 text-center">
    <div class="hidden lg:flex col-span-1"></div>
    <div class="col-span-12 lg:col-span-10"><h1 class="p-1 text-3xl md:text-5xl lg:text-6xl font-semibold">List of Donations</h1></div>
    <div class="hidden lg:flex col-span-1"></div>
</section>

<section class="grid grid-cols-12 flex mt-10">
    <div class="col-span-1"></div>
    <div class="col-span-10 mb-10 md:mb-0 md:col-span-5 flex items-center space-x-2 md:max-w-sm">
        <form class="flex w-full md:w-full items-center space-x-2">
            <Input type="text" placeholder="Search for Recepient" />
            <Button type="submit">Search</Button>
        </form>
    </div>
    <div class="col-span-1 md:hidden"></div>
    <div class="col-span-1 md:hidden"></div>
    <div class="col-span-10 md:col-span-5 flex justify-end">
        <DropdownMenu.Root>
            <DropdownMenu.Trigger asChild let:builder>
              <Button class="w-full md:w-[150px]" variant="outline" builders={[builder]}>{position ? position : "Filter..." }</Button>
            </DropdownMenu.Trigger>
            <DropdownMenu.Content class="w-4/5 md:w-56">
              <DropdownMenu.Label>Filter Ascending</DropdownMenu.Label>
              <DropdownMenu.Separator />
              <DropdownMenu.RadioGroup bind:value={position} class="mb-1">
                <DropdownMenu.RadioItem value="ID Asc...">ID</DropdownMenu.RadioItem>
                <DropdownMenu.RadioItem value="Amount Asc...">Amount</DropdownMenu.RadioItem>
                <DropdownMenu.RadioItem value="Recepient Asc...">Recepient</DropdownMenu.RadioItem>
                <DropdownMenu.RadioItem value="Country Asc...">Country</DropdownMenu.RadioItem>
                <DropdownMenu.Separator />
                <DropdownMenu.Label>Filter Descending</DropdownMenu.Label>
                <DropdownMenu.RadioItem value="ID Desc...">ID</DropdownMenu.RadioItem>
                <DropdownMenu.RadioItem value="Amount Desc...">Amount</DropdownMenu.RadioItem>
                <DropdownMenu.RadioItem value="Recepient Desc...">Recepient</DropdownMenu.RadioItem>
                <DropdownMenu.RadioItem value="Country Desc...">Country</DropdownMenu.RadioItem>
              </DropdownMenu.RadioGroup>
            </DropdownMenu.Content>
          </DropdownMenu.Root>
    </div>
    <div class="col-span-1"></div>
</section>


<section class="grid grid-cols-12 flex justify-center items-center w-full my-10">
    {#if showSkeleton}
        <div class="col-span-1"></div>
        <div class="col-span-10">
            <Table.Root>
                <Table.Caption>A list of transactions</Table.Caption>
                <Table.Header>
                    <Table.Row class="max-[400px]:text-xs max-[500px]:text-md">
                        <Table.Head class="{innerWidth <= 800 ? 'w-[25%]' : 'w-1/10'}">ID</Table.Head>
                        <Table.Head class="{innerWidth <= 800 ? 'w-[32%]' : 'w-1-/10'}">Amount</Table.Head>
                        {#if innerWidth > 800}
                            <Table.Head class="w-1/10">Date</Table.Head>
                            <Table.Head class="w-1/5">Recipient</Table.Head>
                            <Table.Head class="w-1/5">Sender</Table.Head>
                        {/if}
                        <Table.Head class="{innerWidth <= 800 ? 'w-[35%]' : 'w-1/5'} text-right">More Details</Table.Head>
                    </Table.Row>
                </Table.Header>
                <Table.Body>
                    {#each Array.from({ length: 20 }, (_, i) => i) as index}
                        <Table.Row>
                            <Table.Cell class="font-medium">
                                <Skeleton class="w-[40%] h-[27px]" />
                            </Table.Cell>
                            <Table.Cell>
                                <Skeleton class="w-[40%] h-[27px]" />
                            </Table.Cell>
                            {#if innerWidth > 800}
                                <Table.Cell>
                                    <Skeleton class="w-[60%] h-[27px]" />
                                </Table.Cell>
                                <Table.Cell>
                                    <Skeleton class="w-[45%] h-[27px]" />
                                </Table.Cell>
                                <Table.Cell>
                                    <Skeleton class="w-[45%] h-[27px]" />
                                </Table.Cell>
                            {/if}
                            <Table.Cell class="flex justify-end items-end">
                                <Skeleton class="w-[62%] h-[27px]" />
                            </Table.Cell>
                        </Table.Row>
                    {/each}
                </Table.Body>
            </Table.Root>            
            
            <Pagination.Root class="mt-10" count={100} perPage={10} let:pages let:currentPage>
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
                            {#if page.value <= 2 || page.value === pages.length}
                                <Pagination.Item isVisible={currentPage == page.value}>
                                    <Pagination.Link {page} isActive={currentPage == page.value}>
                                        {page.value}
                                    </Pagination.Link>
                                </Pagination.Item>
                            {/if}
                        {/if}
                    {/each}
                    <Pagination.Item>
                        <Pagination.NextButton />
                    </Pagination.Item>
                </Pagination.Content>
            </Pagination.Root>
        </div>
        <div class="col-span-1"></div>
    {:else}
        <div class="col-span-1"></div>
        <div class="col-span-10">
            <Table.Root>
                <Table.Caption>A list of transactions</Table.Caption>
                <Table.Header>
                    <Table.Row class="max-[400px]:text-xs max-[500px]:text-md">
                        <Table.Head class="w-1/10">ID</Table.Head>
                        <Table.Head class="w-1/10">Amount</Table.Head>
                        {#if innerWidth > 800}
                            <Table.Head class="w-1/10">Date</Table.Head>
                            <Table.Head class="w-1/5">Recipient</Table.Head>
                            <Table.Head class="w-1/5">Sender</Table.Head>
                        {/if}
                        <Table.Head class="w-1/5 text-right">More Details</Table.Head>
                    </Table.Row>
                </Table.Header>
                <Table.Body>
                    {#each invoiceList as invoiceArray}
                        {#each invoiceArray as invoice}
                        <Table.Row>
                            <Table.Cell class="font-medium">{invoice.transactionID}</Table.Cell>
                            <Table.Cell>{invoice.transactionAmount.amountBTC} BTC</Table.Cell>
                            {#if innerWidth > 800}
                                <Table.Cell>{new Date(Number(BigInt(invoice.transactionDateTime)) / 1000000).toLocaleDateString('en-GB')}</Table.Cell>
                                <Table.Cell>{invoice.transactionEntityID}</Table.Cell>
                                <Table.Cell>{invoice.sourceBTCAddy}</Table.Cell>
                            {/if}
                            <Table.Cell class="text-right">
                                <Drawer.Root>
                                    <Drawer.Trigger asChild let:builder>
                                      <Button builders={[builder]} variant="outline" class="h-7">View Details</Button>
                                    </Drawer.Trigger>
                                    <Drawer.Content>
                                      <div class="mx-auto w-full max-w-sm">
                                        <Drawer.Header>
                                          <Drawer.Title>Transaction: {invoice.transactionID}</Drawer.Title>
                                          <Drawer.Description>Transaction Status: {invoice.transactionStatus}</Drawer.Description>
                                          <Drawer.Description>Transaction EntityID: {invoice.transactionEntityID}</Drawer.Description>
                                          <Drawer.Description>Transaction Amount Satoshi: {invoice.transactionAmount.amountInSatoshi}</Drawer.Description>
                                          <Drawer.Description>Transaction Amount BTC: {invoice.transactionAmount.amountBTC}</Drawer.Description>
                                          <Drawer.Description>Sender Address: {invoice.sourceBTCAddy}</Drawer.Description>
                                          <Drawer.Description>Transaction Date: {new Date(Number(BigInt(invoice.transactionDateTime)) / 1000000).toLocaleDateString('en-GB')}</Drawer.Description>
                                        </Drawer.Header>
                                        <Drawer.Footer>
                                          <Drawer.Close asChild let:builder>
                                            <Button builders={[builder]} variant="outline">Cancel</Button>
                                          </Drawer.Close>
                                        </Drawer.Footer>
                                      </div>
                                    </Drawer.Content>
                                  </Drawer.Root>
                            </Table.Cell>
                        </Table.Row> 
                        {/each}
                  {/each}
                </Table.Body>
            </Table.Root>
            <Pagination.Root class="mt-10" count={100} perPage={10} let:pages let:currentPage>
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
                            {#if page.value <= 2 || page.value === pages.length}
                                <Pagination.Item isVisible={currentPage == page.value}>
                                    <Pagination.Link {page} isActive={currentPage == page.value}>
                                        {page.value}
                                    </Pagination.Link>
                                </Pagination.Item>
                            {/if}
                        {/if}
                    {/each}
                    <Pagination.Item>
                        <Pagination.NextButton />
                    </Pagination.Item>
                </Pagination.Content>
            </Pagination.Root>
        </div>
        <div class="col-span-1"></div>
    {/if}
</section>
  