<script lang="ts">
    import { onMount } from 'svelte';
    import { Button } from "$lib/components/ui/button";
    import * as Table from "$lib/components/ui/table";
    import * as Pagination from "$lib/components/ui/pagination";
    import Skeleton from '$lib/components/ui/skeleton/skeleton.svelte';
    import * as Drawer from "$lib/components/ui/drawer";
    import { Input } from "$lib/components/ui/input";
    import * as DropdownMenu from "$lib/components/ui/dropdown-menu";
    import { Reload, ChevronDown, ChevronUp } from "radix-icons-svelte";
    import { sortStore, sortStoreTable } from '$lib/data/stores/stores';
    import { actorSorting } from "$lib/motokoImports/backend"
    import { actorBackEndTransaction } from '$lib/motokoImports/backend';

    let actor : any = null;
    let actorBackendTrans : any = null;
    let count = 0;
    let currentPage = 1;
    let pageChange = false;

    let showSkeleton = true;
    let innerWidth : any;
    let defaultResults = false;
    let SearchResults = false;
    let transactionIDinput = "";
    let sorted = false;
    


    let position = "";
    
    let invoiceList: any[] = [];

    onMount(async () => {
        try {
			actor = actorSorting;
            actorBackendTrans = actorBackEndTransaction;

            const countBigInt = await actor.getCountOfAllTransactions();

            count = Number(countBigInt);

            invoiceList = await actor.getAllTransactionTypes(1,20);
            console.log(JSON.stringify(invoiceList, (key, value) =>
            typeof value === 'bigint' ? value.toString() : value
            ));
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
            let response = await actorBackendTrans.getTransactionByIdSharedType(transactionID);
            invoiceList = Array.isArray(response) ? response : [response];
            showSkeleton = false;
            SearchResults = true;
            console.log(JSON.stringify(invoiceList, (key, value) =>
            typeof value === 'bigint' ? value.toString() : value
            ));
            console.log(invoiceList)

        } catch (err: unknown) {
			invoiceList = [];
            showSkeleton = false;
            SearchResults = true;
		};
    }

    const resetResults = async () => {
        try {
            position = "Filter...";
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

    async function handleSorting(sort: string, event? : number) {
        console.log(event)
        if(typeof event === "undefined"){
            event = 1;
        }
        $sortStore = sort;
            console.log($sortStore, event)
        pageChange = true;
        switch (sort) {
            case "ID ASC":
                $sortStore = "ID ASC";
                console.log($sortStore)
                invoiceList = await actor.sortTransactionTypes(event, 20, "ID", true);
                $sortStoreTable = "ID ASC";
                defaultResults = false;
                console.log(invoiceList)
                break;
            case "Amount ASC":
                $sortStore = "Amount ASC";
                console.log($sortStore)
                invoiceList = await actor.sortTransactionTypes(event, 20, "AmountBtc", true);
                $sortStoreTable = "Amount ASC";
                defaultResults = false;
                sorted = true;
                break;
            case "Recipient ASC":
                $sortStore = "Recipient ASC";
                console.log($sortStore)
                invoiceList = await actor.sortTransactionTypes(event, 20, "Recipient", true);
                $sortStoreTable = "Recipient ASC";
                defaultResults = false;
                sorted = true;
                break;
            case "Sender ASC":
                $sortStore = "Sender ASC";
                console.log($sortStore)
                invoiceList = await actor.sortTransactionTypes(event, 20, "Sender", true);
                $sortStoreTable = "Sender ASC";
                defaultResults = false;
                sorted = true;
                break;
            case "ID DESC":
                $sortStore = "ID DESC";
                console.log($sortStore)
                invoiceList = await actor.sortTransactionTypes(event, 20, "ID", false);
                $sortStoreTable = "ID DESC";
                defaultResults = false;
                sorted = true;
                break;
            case "Amount DESC":
                $sortStore = "Amount DESC";
                console.log($sortStore)
                invoiceList = await actor.sortTransactionTypes(event, 20, "AmountBtc", false);
                $sortStoreTable = "Amount DESC";
                defaultResults = false;
                sorted = true;
                break;
            case "Recipient DESC":
                $sortStore = "Recipient DESC";
                console.log($sortStore)
                invoiceList = await actor.sortTransactionTypes(event, 20, "Recipient", false);
                $sortStoreTable = "Recipient DESC";
                defaultResults = false;
                sorted = true;
                break;
            case "Sender DESC":
                $sortStore = "Sender DESC";
                console.log($sortStore)
                invoiceList = await actor.sortTransactionTypes(event, 20, "Sender", false);
                $sortStoreTable = "Sender DESC";
                defaultResults = false;
                sorted = true;
                break;
            default:
                console.error("Unknown sorting option:", sort);
                break;
        }
        currentPage = event;
        pageChange = false;
        sorted = true;
    }
</script>

<svelte:head>
	<title>Transaction - Donation Engine</title>
	<meta name="description" content="View Donation Engine" />
</svelte:head>

<svelte:window bind:innerWidth />

<section class="grid grid-cols-12  text-center">
    <div class="hidden lg:flex col-span-1"></div>
    <div class="col-span-12 lg:col-span-10"><h1 class="p-1 text-3xl md:text-5xl lg:text-6xl font-semibold">List of Donations</h1></div>
    <div class="hidden lg:flex col-span-1"></div>
</section>

<section class="grid grid-cols-12 mt-10">
    <div class="col-span-1"></div>
    <div class="col-span-10 mb-10 md:mb-0 md:col-span-5 flex items-center space-x-2 md:max-w-sm">
        <form class="flex w-full md:w-full items-center space-x-2">
            <Input type="text" placeholder="Search for Recipient" bind:value={transactionIDinput} />
            <Button type="submit" disabled={showSkeleton} on:click="{()=> getTransaction(transactionIDinput)}">Search</Button>
        </form>
    </div>
    <div class="col-span-1 md:hidden"></div>
    <div class="col-span-1 md:hidden"></div>
    <div class="col-span-10 md:col-span-5 flex justify-end {SearchResults ? "hidden" : ""}">
        <DropdownMenu.Root>
            <DropdownMenu.Trigger asChild let:builder>
                <Button disabled={pageChange || SearchResults} class="w-full md:w-[150px]" variant="{SearchResults ? "ghost" : "outline"}" builders={[builder]}>
                    {#if !pageChange && !SearchResults}
                        {position ? position : "Filter..." }
                    {:else if pageChange && !SearchResults}
                        <Reload class="h-4 w-4 animate-spin" />
                    {/if}
                </Button>
            </DropdownMenu.Trigger>
            <DropdownMenu.Content class="w-4/5 md:w-56">
              <DropdownMenu.Label>Filter Ascending</DropdownMenu.Label>
              <DropdownMenu.Separator />
              <DropdownMenu.RadioGroup bind:value={position} class="mb-1">
                <DropdownMenu.RadioItem value="ID Asc..." on:click={() => handleSorting("ID ASC")}>ID</DropdownMenu.RadioItem>
                <DropdownMenu.RadioItem value="Amount Asc..." on:click={() => handleSorting("Amount ASC")}>Amount</DropdownMenu.RadioItem>
                <DropdownMenu.RadioItem value="Recipient Asc..." on:click={() => handleSorting("Recipient ASC")}>Recipient</DropdownMenu.RadioItem>
                <DropdownMenu.RadioItem value="Sender Asc..." on:click={() => handleSorting("Sender ASC")}>Sender</DropdownMenu.RadioItem>
                <DropdownMenu.Separator />
                <DropdownMenu.Label>Filter Descending</DropdownMenu.Label>
                <DropdownMenu.RadioItem value="ID Desc..." on:click={() => handleSorting("ID DESC")}>ID</DropdownMenu.RadioItem>
                <DropdownMenu.RadioItem value="Amount Desc..." on:click={() => handleSorting("Amount DESC")}>Amount</DropdownMenu.RadioItem>
                <DropdownMenu.RadioItem value="Recipient Desc..." on:click={() => handleSorting("Recipient DESC")}>Recipient</DropdownMenu.RadioItem>
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
    <div class="col-span-10 md:col-span-5 flex justify-end {SearchResults ? "" : "hidden"}">
          <Button 
            type="submit"
            on:click={showSkeleton === false ? resetResults : null}
            disabled={showSkeleton || defaultResults}
            class="{innerWidth > 800 ? "w-44" :"w-full"}"
           >
            Reset
           </Button>
    </div>
    <div class="col-span-1"></div>
</section>


<section class="grid grid-cols-12 w-full my-10 min-h-fit">
    {#if showSkeleton}
        <div class="col-span-1"></div>
        <div class="col-span-10">
            <Table.Root>
                <Table.Caption>Donation Transaction Explorer</Table.Caption>
                <Table.Header>
                    <Table.Row class="max-[400px]:text-xs max-[500px]:text-md">
                        <Table.Head class="{innerWidth <= 800 ? 'w-[33%]' : 'w-1/5'}">Transaction ID</Table.Head>
                        {#if innerWidth > 800}
                            <Table.Head class="{innerWidth <= 800 ? 'w-[32%]' : 'w-1-/10'}">Amount</Table.Head>
                            <Table.Head class="w-1/10">Date</Table.Head>
                            <Table.Head class="w-1/10">Recipient</Table.Head>
                            <Table.Head class="w-1/5">Sender</Table.Head>
                        {/if}
                        <Table.Head class="{innerWidth <= 800 ? 'w-[33%]' : 'w-1-/10'}">Status</Table.Head>
                        <Table.Head class="{innerWidth <= 800 ? 'w-[43%]' : 'w-1/5'} text-right">More Details</Table.Head>
                    </Table.Row>
                </Table.Header>
                <Table.Body>
                    {#each Array.from({ length: 20 }, (_, i) => i) as index}
                        <Table.Row>
                            <Table.Cell class="font-medium">
                                <Skeleton class="w-[60%] h-[27px]" />
                            </Table.Cell>
                            {#if innerWidth > 800}
                                <Table.Cell>
                                    <Skeleton class="w-[40%] h-[27px]" />
                                </Table.Cell>
                                <Table.Cell>
                                    <Skeleton class="w-[60%] h-[27px]" />
                                </Table.Cell>
                                <Table.Cell>
                                    <Skeleton class="w-[60%] h-[27px]" />
                                </Table.Cell>
                                <Table.Cell>
                                    <Skeleton class="w-[45%] h-[27px]" />
                                </Table.Cell>
                                
                            {/if}
                            <Table.Cell>
                                <Skeleton class="w-[45%] h-[27px]" />
                            </Table.Cell>
                            <Table.Cell class="flex justify-end items-end">
                                <Skeleton class="w-[40%] h-[27px]" />
                            </Table.Cell>
                        </Table.Row>
                    {/each}
                </Table.Body>
            </Table.Root>
        </div>
        <div class="col-span-1"></div>
    {:else}
        {#if defaultResults}
            {#if invoiceList.length > 0}
                <div class="col-span-1"></div>
                <div class="col-span-10">
                    <Table.Root>
                        <Table.Caption>Donation Transaction Explorer</Table.Caption>
                        <Table.Header>
                            <Table.Row class="max-[400px]:text-xs max-[500px]:text-md">
                                <Table.Head class="w-1/5">Transaction ID</Table.Head>
                                {#if innerWidth > 800}
                                    <Table.Head class="w-1/10">Amount</Table.Head>
                                    <Table.Head class="w-1/10">Date</Table.Head>
                                    <Table.Head class="w-1/10">Recipient</Table.Head>
                                    <Table.Head class="w-1/5">Sender</Table.Head>
                                {/if}
                                <Table.Head class="{innerWidth <= 800 ? 'w-[32%]' : 'w-1-/10'}">Status</Table.Head>
                                <Table.Head class="w-1/5 text-right">More Details</Table.Head>
                            </Table.Row>
                        </Table.Header>
                        <Table.Body>
                            {#each invoiceList as invoice}
                            <Table.Row>
                                <Table.Cell class="font-medium">{invoice.BTC.commonTransactionDetails.transactionId}</Table.Cell>
                                {#if innerWidth > 800}
                                    <Table.Cell>{invoice.BTC.commonTransactionDetails.amounts[0].amount} BTC</Table.Cell>
                                    <Table.Cell>{new Date(Number(BigInt(invoice.BTC.commonTransactionDetails.receivedTime)) / 1000000).toLocaleDateString('en-GB')}</Table.Cell>
                                    <Table.Cell>{invoice.BTC.commonTransactionDetails.receivingEntityName}</Table.Cell>
                                    <Table.Cell>{invoice.BTC.sourceBtcAddress}</Table.Cell>
                                {/if}
                                {#if 'pending' in invoice.BTC.commonTransactionDetails.status}
                                    <Table.Cell><span class="rounded-sm bg-yellow-400 border-yellow-500 text-white px-2 py-0.5 bg-opacity-75">Pending</span></Table.Cell>
                                {:else if 'rejected' in invoice.BTC.commonTransactionDetails.status}
                                    <Table.Cell><span class="rounded-sm bg-red-600 border-red-500 text-white px-2 py-0.5 bg-opacity-75">Rejected</span></Table.Cell>
                                {:else if 'confirmed' in invoice.BTC.commonTransactionDetails.status}
                                    <Table.Cell><span class="rounded-sm bg-green-600 border-green-500 text-white px-2 py-0.5 bg-opacity-75">Confirmed</span></Table.Cell>
                                {/if}
                                <Table.Cell class="text-right">
                                    <Drawer.Root>
                                        <Drawer.Trigger asChild let:builder>
                                        <Button builders={[builder]} variant="outline" class="h-7">View Details</Button>
                                        </Drawer.Trigger>
                                        <Drawer.Content>
                                        <div class="mx-auto w-full max-w-sm break-all">
                                            <Drawer.Header>
                                            <Drawer.Title class="mb-5 leading-7">Transaction: {invoice.BTC.commonTransactionDetails.transactionId}</Drawer.Title>
                                            <Drawer.Description>Transaction Status: 
                                                {#if 'pending' in invoice.BTC.commonTransactionDetails.status}
                                                    <span class="rounded-sm bg-yellow-400 border-yellow-500 text-white px-2 bg-opacity-75">Pending</span>
                                                {:else if 'rejected' in invoice.BTC.commonTransactionDetails.status}
                                                    <span class="rounded-sm bg-red-600 border-red-500 text-white px-2 bg-opacity-75">Rejected</span>
                                                {:else if 'confirmed' in invoice.BTC.commonTransactionDetails.status}
                                                    <span class="rounded-sm bg-green-600 border-green-500 text-white px-2 bg-opacity-75">Confirmed</span>
                                                {/if}       
                                            </Drawer.Description>
                                            <Drawer.Description>Transaction Recipient: {invoice.BTC.commonTransactionDetails.receivingEntityName}</Drawer.Description>
                                            <Drawer.Description>Transaction EntityID: {invoice.BTC.commonTransactionDetails.receivingEntityId}</Drawer.Description>
                                            <Drawer.Description>Transaction Amount BTC: {invoice.BTC.commonTransactionDetails.amounts[1].amount}</Drawer.Description>
                                            <Drawer.Description>Transaction Amount Satoshi: {invoice.BTC.commonTransactionDetails.amounts[0].amount}</Drawer.Description>
                                            <Drawer.Description>Sender Address: {invoice.BTC.sourceBtcAddress}</Drawer.Description>
                                            <Drawer.Description>Transaction Date: {new Date(Number(BigInt(invoice.BTC.commonTransactionDetails.receivedTime)) / 1000000).toLocaleDateString('en-GB')}</Drawer.Description>
                                            <Drawer.Description class="font-semibold mt-3">Recieving Entities Precentages </Drawer.Description>
                                            <Drawer.Description>Curriculum Design and Development: {invoice.BTC.commonTransactionDetails.receivers[0].percentage}%</Drawer.Description>
                                            <Drawer.Description>Teacher Support: {invoice.BTC.commonTransactionDetails.receivers[3].percentage}%</Drawer.Description>
                                            <Drawer.Description>School Supplies: {invoice.BTC.commonTransactionDetails.receivers[5].percentage}%</Drawer.Description>
                                            <Drawer.Description>Lunch and Snacks: {invoice.BTC.commonTransactionDetails.receivers[7].percentage}%</Drawer.Description>
                                            <Drawer.Description class="mt-3 font-bold text-blue-500 hover:text-blue-700 active:text-blue-900"><a target="_blank" href="https://live.blockcypher.com/btc-testnet/tx/{invoice.BTC.commonTransactionDetails.transactionId}/">View More Details in Blockcypher</a></Drawer.Description>
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
                        </Table.Body>
                    </Table.Root>
                    {#if !SearchResults}
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
                                        {:else if (pageChange && currentPage != page.value) ||(pageChange && currentPage > page.value+1) ||(pageChange && currentPage < page.value+1)}
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
                    {/if}
                </div>
                <div class="col-span-1"></div>
            {:else if invoiceList.length <= 0}
            <div class="col-span-1"></div>
                <div class="col-span-10">
                    <p>No Results Found.</p>
                </div>
                <div class="col-span-1"></div>
            {/if}
        {:else if sorted}
            {#if invoiceList.length > 0}
                <div class="col-span-1"></div>
                <div class="col-span-10">
                    <Table.Root>
                        <Table.Caption>Donation Transaction Explorer</Table.Caption>
                        <Table.Header>
                            <Table.Row class="max-[400px]:text-xs max-[500px]:text-md">
                                {#if $sortStoreTable == "ID ASC"}
                                    <Table.Head class=" flex items-center bg-stone-100">Transaction ID <ChevronUp /> </Table.Head>
                                {:else if $sortStoreTable == "ID DESC"}
                                    <Table.Head class=" flex items-center bg-stone-100">Transaction ID <ChevronDown/> </Table.Head>
                                {:else}
                                    <Table.Head class="">ID</Table.Head>
                                {/if}
                                {#if innerWidth > 800}
                                    {#if $sortStoreTable == "Amount ASC"}
                                        <Table.Head class=" flex items-center bg-stone-100">Amount <ChevronUp /> </Table.Head>
                                    {:else if $sortStoreTable == "Amount DESC"}
                                        <Table.Head class=" flex items-center bg-stone-100">Amount <ChevronDown/></Table.Head>
                                    {:else}
                                        <Table.Head class="">Amount</Table.Head>
                                    {/if}
                                    <Table.Head class="">Date</Table.Head>
                                    {#if $sortStoreTable == "Recipient ASC"}
                                        <Table.Head class=" flex items-center bg-stone-100">Recipient <ChevronUp /></Table.Head>
                                    {:else if $sortStoreTable == "Recipient DESC"}
                                        <Table.Head class="flex items-center bg-stone-100">Recipient <ChevronDown/></Table.Head>
                                    {:else}
                                        <Table.Head class="">Recipient</Table.Head>
                                    {/if}
                                    {#if $sortStoreTable == "Sender ASC"}
                                        <Table.Head class=" flex items-center bg-stone-100">Sender <ChevronUp /></Table.Head>
                                    {:else if $sortStoreTable == "Sender DESC"}
                                        <Table.Head class=" flex items-center bg-stone-100">Sender <ChevronDown/></Table.Head>
                                    {:else}
                                        <Table.Head class="">Sender</Table.Head>
                                    {/if}
                                {:else if innerWidth < 800}
                                    {#if $sortStoreTable == "Amount ASC"}
                                        <Table.Head class=" flex items-center bg-stone-100">Amount <ChevronUp /> </Table.Head>
                                    {:else if $sortStoreTable == "Amount DESC"}
                                        <Table.Head class=" flex items-center bg-stone-100">Amount <ChevronDown/></Table.Head>
                                    {:else if $sortStoreTable == "Recipient ASC"}
                                        <Table.Head class=" flex items-center bg-stone-100">Recipient <ChevronUp /></Table.Head>
                                    {:else if $sortStoreTable == "Recipient DESC"}
                                        <Table.Head class="flex items-center bg-stone-100">Recipient <ChevronDown/></Table.Head>
                                    {:else if $sortStoreTable == "Sender ASC"}
                                        <Table.Head class=" flex items-center bg-stone-100">Sender <ChevronUp /></Table.Head>
                                    {:else if $sortStoreTable == "Sender ASC"}
                                        <Table.Head class=" flex items-center bg-stone-100">Sender <ChevronDown/></Table.Head>
                                    {/if}
                                {/if}
                                <Table.Head class="{innerWidth <= 800 ? 'w-[32%]' : 'w-1-/10'}">Status</Table.Head>
                                <Table.Head class=" text-right">More Details</Table.Head>
                            </Table.Row>
                        </Table.Header>
                        <Table.Body>
                            {#each invoiceList as invoice}
                            <Table.Row>
                                <Table.Cell class="font-medium">{invoice.BTC.commonTransactionDetails.transactionId}</Table.Cell>
                                {#if innerWidth > 800}
                                    <Table.Cell>{invoice.BTC.commonTransactionDetails.amounts[0].amount} BTC</Table.Cell>
                                    <Table.Cell>{new Date(Number(BigInt(invoice.BTC.commonTransactionDetails.receivedTime)) / 1000000).toLocaleDateString('en-GB')}</Table.Cell>
                                    <Table.Cell>{invoice.BTC.commonTransactionDetails.receivingEntityName}</Table.Cell>
                                    <Table.Cell>{invoice.BTC.sourceBtcAddress}</Table.Cell>
                                {:else if innerWidth < 800}
                                    {#if $sortStoreTable == "Amount ASC" || $sortStoreTable == "Amount DESC"}
                                        <Table.Cell>{invoice.BTC.commonTransactionDetails.amounts[0].amount} BTC</Table.Cell>
                                    {:else if $sortStoreTable == "Recipient ASC" || $sortStoreTable == "Recipient DESC"}
                                        <Table.Cell>{invoice.BTC.commonTransactionDetails.receivingEntityName}</Table.Cell>
                                    {:else if $sortStoreTable == "Sender ASC" || $sortStoreTable == "Sender DESC"}
                                        <Table.Cell>{invoice.BTC.sourceBtcAddress}</Table.Cell>
                                    {/if}
                                {/if}
                                {#if 'pending' in invoice.BTC.commonTransactionDetails.status}
                                    <Table.Cell><span class="rounded-sm bg-yellow-400 border-yellow-500 text-white px-2 py-0.5 bg-opacity-75">Pending</span></Table.Cell>
                                {:else if 'rejected' in invoice.BTC.commonTransactionDetails.status}
                                    <Table.Cell><span class="rounded-sm bg-red-600 border-red-500 text-white px-2 py-0.5 bg-opacity-75">Rejected</span></Table.Cell>
                                {:else if 'confirmed' in invoice.BTC.commonTransactionDetails.status}
                                    <Table.Cell><span class="rounded-sm bg-green-600 border-green-500 text-white px-2 py-0.5 bg-opacity-75">Confirmed</span></Table.Cell>
                                {/if}
                                <Table.Cell class="text-right">
                                    <Drawer.Root>
                                        <Drawer.Trigger asChild let:builder>
                                        <Button builders={[builder]} variant="outline" class="h-7">View Details</Button>
                                        </Drawer.Trigger>
                                        <Drawer.Content>
                                        <div class="mx-auto w-full max-w-sm break-all">
                                            <Drawer.Header>
                                                <Drawer.Title class="mb-5 leading-7">Transaction: {invoice.BTC.commonTransactionDetails.transactionId}</Drawer.Title>
                                                <Drawer.Description>Transaction Status: 
                                                    {#if 'pending' in invoice.BTC.commonTransactionDetails.status}
                                                        <span class="rounded-sm bg-yellow-400 border-yellow-500 text-white px-2 bg-opacity-75">Pending</span>
                                                    {:else if 'rejected' in invoice.BTC.commonTransactionDetails.status}
                                                        <span class="rounded-sm bg-red-600 border-red-500 text-white px-2 bg-opacity-75">Rejected</span>
                                                    {:else if 'confirmed' in invoice.BTC.commonTransactionDetails.status}
                                                        <span class="rounded-sm bg-green-600 border-green-500 text-white px-2 bg-opacity-75">Confirmed</span>
                                                    {/if}     
                                                </Drawer.Description>
                                                <Drawer.Description>Transaction Recipient: {invoice.BTC.commonTransactionDetails.receivingEntityName}</Drawer.Description>
                                                <Drawer.Description>Transaction EntityID: {invoice.BTC.commonTransactionDetails.receivingEntityId}</Drawer.Description>
                                                <Drawer.Description>Transaction Amount BTC: {invoice.BTC.commonTransactionDetails.amounts[1].amount}</Drawer.Description>
                                                <Drawer.Description>Transaction Amount Satoshi: {invoice.BTC.commonTransactionDetails.amounts[0].amount}</Drawer.Description>
                                                <Drawer.Description>Sender Address: {invoice.BTC.sourceBtcAddress}</Drawer.Description>
                                                <Drawer.Description>Transaction Date: {new Date(Number(BigInt(invoice.BTC.commonTransactionDetails.receivedTime)) / 1000000).toLocaleDateString('en-GB')}</Drawer.Description>
                                                <Drawer.Description class="font-semibold mt-3">Recieving Entities Precentages </Drawer.Description>
                                                <Drawer.Description>Curriculum Design and Development: {invoice.BTC.commonTransactionDetails.receivers[0].percentage}%</Drawer.Description>
                                                <Drawer.Description>Teacher Support: {invoice.BTC.commonTransactionDetails.receivers[3].percentage}%</Drawer.Description>
                                                <Drawer.Description>School Supplies: {invoice.BTC.commonTransactionDetails.receivers[5].percentage}%</Drawer.Description>
                                                <Drawer.Description>Lunch and Snacks: {invoice.BTC.commonTransactionDetails.receivers[7].percentage}%</Drawer.Description>
                                                <Drawer.Description class="mt-3 font-bold text-blue-500 hover:text-blue-700 active:text-blue-900"><a target="_blank" href="https://live.blockcypher.com/btc-testnet/tx/{invoice.BTC.commonTransactionDetails.transactionId}/">View More Details in Blockcypher</a></Drawer.Description>
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
                        </Table.Body>
                    </Table.Root>
                    {#if !SearchResults}
                        <Pagination.Root class="mt-10" count={count} perPage={20} let:pages let:range currentPage={currentPage} onPageChange={(event) => handleSorting($sortStore, event)}>
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
                                <Pagination.Item isVisible={currentPage == page.value} >
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
                    {/if}
                </div>
                <div class="col-span-1"></div>
            {:else if invoiceList.length <= 0}
            <div class="col-span-1"></div>
                <div class="col-span-10">
                    <p>No Results Found.</p>
                </div>
                <div class="col-span-1"></div>
            {/if}
        {:else if SearchResults}
            {#if invoiceList.length > 0}
                <div class="col-span-1"></div>
                <div class="col-span-10">
                    <Table.Root>
                        <Table.Caption>Donation Transaction Explorer</Table.Caption>
                        <Table.Header>
                            <Table.Row class="max-[400px]:text-xs max-[500px]:text-md">
                                <Table.Head class="w-1/10">Transaction ID</Table.Head>
                                {#if innerWidth > 800}
                                    <Table.Head class="w-1/10">Amount</Table.Head>
                                    <Table.Head class="w-1/10">Date</Table.Head>
                                    <Table.Head class="w-1/5">Recipient</Table.Head>
                                    <Table.Head class="w-1/5">Sender</Table.Head>
                                {/if}
                                <Table.Head class="{innerWidth <= 800 ? 'w-[32%]' : 'w-1-/10'}">Status</Table.Head>
                                <Table.Head class="w-1/5 text-right">More Details</Table.Head>
                            </Table.Row>
                        </Table.Header>
                        <Table.Body>
                            {#each invoiceList as invoice}
                            <Table.Row>
                                <Table.Cell class="font-medium">{invoice.BTC.commonTransactionDetails.transactionId}</Table.Cell>
                                {#if innerWidth > 800}
                                    <Table.Cell>{invoice.BTC.commonTransactionDetails.amounts[0].amount} BTC</Table.Cell>
                                    <Table.Cell>{new Date(Number(BigInt(invoice.BTC.commonTransactionDetails.receivedTime)) / 1000000).toLocaleDateString('en-GB')}</Table.Cell>
                                    <Table.Cell>{invoice.BTC.commonTransactionDetails.receivingEntityName}</Table.Cell>
                                    <Table.Cell>{invoice.BTC.sourceBtcAddress}</Table.Cell>
                                {/if}
                                {#if 'pending' in invoice.BTC.commonTransactionDetails.status}
                                    <Table.Cell><span class="rounded-sm bg-yellow-400 border-yellow-500 text-white px-2 py-0.5 bg-opacity-75">Pending</span></Table.Cell>
                                {:else if 'rejected' in invoice.BTC.commonTransactionDetails.status}
                                    <Table.Cell><span class="rounded-sm bg-red-600 border-red-500 text-white px-2 py-0.5 bg-opacity-75">Rejected</span></Table.Cell>
                                {:else if 'confirmed' in invoice.BTC.commonTransactionDetails.status}
                                    <Table.Cell><span class="rounded-sm bg-green-600 border-green-500 text-white px-2 py-0.5 bg-opacity-75">Confirmed</span></Table.Cell>
                                {/if}
                                <Table.Cell class="text-right">
                                    <Drawer.Root>
                                        <Drawer.Trigger asChild let:builder>
                                        <Button builders={[builder]} variant="outline" class="h-7">View Details</Button>
                                        </Drawer.Trigger>
                                        <Drawer.Content>
                                        <div class="mx-auto w-full max-w-sm break-all">
                                            <Drawer.Header>
                                                <Drawer.Title class="mb-5 leading-7">Transaction: {invoice.BTC.commonTransactionDetails.transactionId}</Drawer.Title>
                                                <Drawer.Description>Transaction Status: 
                                                    {#if 'pending' in invoice.BTC.commonTransactionDetails.status}
                                                        <span class="rounded-sm bg-yellow-400 border-yellow-500 text-white px-2 bg-opacity-75">Pending</span>
                                                    {:else if 'rejected' in invoice.BTC.commonTransactionDetails.status}
                                                        <span class="rounded-sm bg-red-600 border-red-500 text-white px-2 bg-opacity-75">Rejected</span>
                                                    {:else if 'confirmed' in invoice.BTC.commonTransactionDetails.status}
                                                        <span class="rounded-sm bg-green-600 border-green-500 text-white px-2 bg-opacity-75">Confirmed</span>
                                                    {/if}  
                                                </Drawer.Description>
                                                <Drawer.Description>Transaction Recipient: {invoice.BTC.commonTransactionDetails.receivingEntityName}</Drawer.Description>
                                                <Drawer.Description>Transaction EntityID: {invoice.BTC.commonTransactionDetails.receivingEntityId}</Drawer.Description>
                                                <Drawer.Description>Transaction Amount BTC: {invoice.BTC.commonTransactionDetails.amounts[1].amount}</Drawer.Description>
                                                <Drawer.Description>Transaction Amount Satoshi: {invoice.BTC.commonTransactionDetails.amounts[0].amount}</Drawer.Description>
                                                <Drawer.Description>Sender Address: {invoice.BTC.sourceBtcAddress}</Drawer.Description>
                                                <Drawer.Description>Transaction Date: {new Date(Number(BigInt(invoice.BTC.commonTransactionDetails.receivedTime)) / 1000000).toLocaleDateString('en-GB')}</Drawer.Description>
                                                <Drawer.Description class="font-semibold mt-3">Recieving Entities Precentages </Drawer.Description>
                                                <Drawer.Description>Curriculum Design and Development: {invoice.BTC.commonTransactionDetails.receivers[0].percentage}%</Drawer.Description>
                                                <Drawer.Description>Teacher Support: {invoice.BTC.commonTransactionDetails.receivers[3].percentage}%</Drawer.Description>
                                                <Drawer.Description>School Supplies: {invoice.BTC.commonTransactionDetails.receivers[5].percentage}%</Drawer.Description>
                                                <Drawer.Description>Lunch and Snacks: {invoice.BTC.commonTransactionDetails.receivers[7].percentage}%</Drawer.Description>
                                                <Drawer.Description class="mt-3 font-bold text-blue-500 hover:text-blue-700 active:text-blue-900"><a target="_blank" href="https://live.blockcypher.com/btc-testnet/tx/{invoice.BTC.commonTransactionDetails.transactionId}/">View More Details in Blockcypher</a></Drawer.Description>
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
                        </Table.Body>
                    </Table.Root>
                </div>
                <div class="col-span-1"></div>
            {:else if invoiceList.length <= 0}
            <div class="col-span-1"></div>
                <div class="col-span-10">
                    <p>No Results Found.</p>
                </div>
                <div class="col-span-1"></div>
            {/if}
        {/if}
    {/if}
</section>