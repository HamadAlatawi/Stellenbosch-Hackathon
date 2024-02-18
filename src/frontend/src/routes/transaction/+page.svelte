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
    import { Reload } from "radix-icons-svelte";

    let actor : any = null;
    let count = 0;
    let currentPage = 1;
    let pageChange = false;

    let showSkeleton = true;
    let innerWidth : any;
    let defaultResults = false;
    let SearchResults = false;
    let transactionIDinput = "";
    


    let position = "";
    
    let invoiceList: any[] = [];

    onMount(async () => {
        try {
			// Canister IDs are automatically expanded to .env config - see vite.config.ts
			const canisterId = import.meta.env.VITE_BACKENDTRANSACTION_CANISTER_ID;

			// We pass the host instead of using a proxy to support NodeJS >= v17 (ViteJS issue: https://github.com/vitejs/vite/issues/4794)
			const host = import.meta.env.VITE_HOST;

			// Create an actor to interact with the IC for a particular canister ID
			actor = createActorBackendTransaction(canisterId, { agentOptions: { host } });

            const countBigInt = await actor.getCountOfAllTransactions();

            count = Number(countBigInt);

            invoiceList = await actor.getAllTransactionTypes(1,20);
            console.log(invoiceList)
            showSkeleton = false;
            defaultResults = true;
		} catch (err: unknown) {
			console.error(err);
		};
    });

    const getTransaction = async (transactionID : string) =>{
        try {
            defaultResults = false;
            SearchResults = false;
            showSkeleton = true;
            invoiceList = [await actor.getTransactionTypeById(transactionID)];
            showSkeleton = false;
            SearchResults = true;
            console.log(invoiceList)

        } catch (err: unknown) {
			console.error(err);
		};
    }

    const resetResults = async () => {
        try {
            defaultResults = false;
            transactionIDinput = "";
            SearchResults = false;
            showSkeleton = true;
            invoiceList = await actor.getAllTransactionTypes(1,20);
            showSkeleton = false;
            defaultResults = true;
            console.log(invoiceList)

        } catch (err: unknown) {
			console.error(err);
		};
    }


    async function defaultPageChange(event : number){
        try{
            pageChange = true;
            invoiceList = await actor.getAllTransactionTypes(event,20);
            currentPage = event;
            pageChange = false;
        }catch (err: unknown) {
			console.error(err);
		};
    };

    async function handleSorting(sort: string) {
        switch (sort) {
            case "ID ASC":
                // Sorting logic for ID in ascending order
                break;
            case "Amount ASC":
                // Sorting logic for Amount in ascending order
                break;
            case "Recepient ASC":
                // Sorting logic for Recepient in ascending order
                break;
            case "Sender ASC":
                // Sorting logic for Sender in ascending order
                break;
            case "ID DESC":
                // Sorting logic for ID in descending order
                break;
            case "Amount DESC":
                // Sorting logic for Amount in descending order
                break;
            case "Recepient DESC":
                // Sorting logic for Recepient in descending order
                break;
            case "Sender DESC":
                // Sorting logic for Sender in descending order
                break;
            default:
                console.error("Unknown sorting option:", sort);
                break;
        }
    }

    
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
            <Input type="text" placeholder="Search for Recepient" bind:value={transactionIDinput} />
            <Button type="submit" disabled={showSkeleton} on:click="{()=> getTransaction(transactionIDinput)}">Search</Button>
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
                <DropdownMenu.RadioItem value="ID Asc..." on:click={() => handleSorting("ID ASC")}>ID</DropdownMenu.RadioItem>
                <DropdownMenu.RadioItem value="Amount Asc..." on:click={() => handleSorting("Amount ASC")}>Amount</DropdownMenu.RadioItem>
                <DropdownMenu.RadioItem value="Recepient Asc..." on:click={() => handleSorting("Recepient ASC")}>Recepient</DropdownMenu.RadioItem>
                <DropdownMenu.RadioItem value="Sender Asc..." on:click={() => handleSorting("Sender ASC")}>Sender</DropdownMenu.RadioItem>
                <DropdownMenu.Separator />
                <DropdownMenu.Label>Filter Descending</DropdownMenu.Label>
                <DropdownMenu.RadioItem value="ID Desc..." on:click={() => handleSorting("ID DESC")}>ID</DropdownMenu.RadioItem>
                <DropdownMenu.RadioItem value="Amount Desc..." on:click={() => handleSorting("Amount DESC")}>Amount</DropdownMenu.RadioItem>
                <DropdownMenu.RadioItem value="Recepient Desc..." on:click={() => handleSorting("Recepient DESC")}>Recepient</DropdownMenu.RadioItem>
                <DropdownMenu.RadioItem value="Sender Desc..." on:click={() => handleSorting("Sender DESC")}>Sender</DropdownMenu.RadioItem>
              </DropdownMenu.RadioGroup>
            </DropdownMenu.Content>
          </DropdownMenu.Root>
          <Button 
            type="submit"
            on:click={showSkeleton === false ? resetResults : null}
            disabled={showSkeleton || defaultResults}
            class="ml-2"
           >
            Reset
           </Button>
    </div>
    <div class="col-span-1"></div>
</section>


<section class="grid grid-cols-12 w-full my-10 min-h-screen">
    {#if showSkeleton}
        <div class="col-span-1"></div>
        <div class="col-span-10">
            <Table.Root>
                <Table.Caption>Donation Transaction Explorer</Table.Caption>
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
        </div>
        <div class="col-span-1"></div>
    {:else}
        {#if defaultResults}
            {#if invoiceList[0].length > 0}
                <div class="col-span-1"></div>
                <div class="col-span-10">
                    <Table.Root>
                        <Table.Caption>Donation Transaction Explorer</Table.Caption>
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
                                        <Table.Cell>{invoice.transactionReceivers[0].benificiary.donation}</Table.Cell>
                                        <Table.Cell>{invoice.sourceBTCAddy}</Table.Cell>
                                    {/if}
                                    <Table.Cell class="text-right">
                                        <Drawer.Root>
                                            <Drawer.Trigger asChild let:builder>
                                            <Button builders={[builder]} variant="outline" class="h-7">View Details</Button>
                                            </Drawer.Trigger>
                                            <Drawer.Content>
                                            <div class="mx-auto w-full max-w-sm break-all">
                                                <Drawer.Header>
                                                <Drawer.Title class="mb-5 leading-7">Transaction: {invoice.transactionID}</Drawer.Title>
                                                <Drawer.Description>Transaction Status: 
                                                    {#if 'pending' in invoice.transactionStatus}
                                                    Pending
                                                    {:else if 'rejected' in invoice.transactionStatus}
                                                        Rejected
                                                    {:else}
                                                        Confirmed
                                                    {/if}     
                                                </Drawer.Description>
                                                <Drawer.Description>Transaction Recipient: {invoice.transactionReceivers[0].benificiary.donation}</Drawer.Description>
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
                    <Pagination.Root class="mt-10" count={count} perPage={20} let:pages let:range currentPage={currentPage} onPageChange={defaultPageChange}>
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
                                    {#if currentPage == page.value || !pageChange}
                                        {page.value}
                                    {:else if pageChange && currentPage != page.value}
                                        <Reload class="h-4 w-4 animate-spin" />
                                    {/if}
                                </Pagination.Link>
                            </Pagination.Item>
                            {/if}
                        {/each}
                        <Pagination.Item>
                            <Pagination.NextButton />
                        </Pagination.Item>
                        </Pagination.Content>
                        <p class="text-center text-xs mt-2 text-muted-foreground">
                            Showing {range.start} - {range.end}
                        </p>
                    </Pagination.Root>
                </div>
                <div class="col-span-1"></div>
            {:else if invoiceList[0].length <= 0}
            <div class="col-span-1"></div>
                <div class="col-span-10">
                    <p>No Results Found.</p>
                </div>
                <div class="col-span-1"></div>
            {/if}
        {:else if SearchResults}
            {#if invoiceList[0].length > 0}
                <div class="col-span-1"></div>
                <div class="col-span-10">
                    <Table.Root>
                        <Table.Caption>Donation Transaction Explorer</Table.Caption>
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
                                        <Table.Cell>{invoice.transactionReceivers[0].benificiary.donation}</Table.Cell>
                                        <Table.Cell>{invoice.sourceBTCAddy}</Table.Cell>
                                    {/if}
                                    <Table.Cell class="text-right">
                                        <Drawer.Root>
                                            <Drawer.Trigger asChild let:builder>
                                            <Button builders={[builder]} variant="outline" class="h-7">View Details</Button>
                                            </Drawer.Trigger>
                                            <Drawer.Content>
                                            <div class="mx-auto w-full max-w-sm break-all">
                                                <Drawer.Header>
                                                <Drawer.Title class="mb-5 leading-7">Transaction: {invoice.transactionID}</Drawer.Title>
                                                <Drawer.Description>Transaction Status: 
                                                    {#if 'pending' in invoice.transactionStatus}
                                                    Pending
                                                    {:else if 'rejected' in invoice.transactionStatus}
                                                        Rejected
                                                    {:else}
                                                        Confirmed
                                                    {/if}     
                                                </Drawer.Description>                                                
                                                <Drawer.Description>Transaction Recipient: {invoice.transactionReceivers[0].benificiary.donation}</Drawer.Description>
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
                </div>
                <div class="col-span-1"></div>
            {:else if invoiceList[0].length <= 0}
            <div class="col-span-1"></div>
                <div class="col-span-10">
                    <p>No Results Found.</p>
                </div>
                <div class="col-span-1"></div>
            {/if}
        {/if}
    {/if}
</section>