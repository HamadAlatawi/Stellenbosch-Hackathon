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

    let actor : any = null;
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
            invoiceList = await actor.getTransactionTypeById(transactionID);
            showSkeleton = false;
            SearchResults = true;
            console.log(invoiceList)

        } catch (err: unknown) {
			console.error(err);
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
                invoiceList = await actor.sortTransactionTypes(event, 20, "Amount", true);
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
                invoiceList = await actor.sortTransactionTypes(event, 20, "Amount", false);
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

<section class="grid grid-cols-12 flex text-center">
    <div class="hidden lg:flex col-span-1"></div>
    <div class="col-span-12 lg:col-span-10"><h1 class="p-1 text-3xl md:text-5xl lg:text-6xl font-semibold">List of Donations</h1></div>
    <div class="hidden lg:flex col-span-1"></div>
</section>

<section class="grid grid-cols-12 flex mt-10">
    <div class="col-span-1"></div>
    <div class="col-span-10 mb-10 md:mb-0 md:col-span-5 flex items-center space-x-2 md:max-w-sm">
        <form class="flex w-full md:w-full items-center space-x-2">
            <Input type="text" placeholder="Search for Recipient" bind:value={transactionIDinput} />
            <Button type="submit" disabled={showSkeleton} on:click="{()=> getTransaction(transactionIDinput)}">Search</Button>
        </form>
    </div>
    <div class="col-span-1 md:hidden"></div>
    <div class="col-span-1 md:hidden"></div>
    <div class="col-span-10 md:col-span-5 flex justify-end">
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
            {#if invoiceList.length > 0}
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
                            {#each invoiceList as invoice}
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
                                {#if innerWidth > 800}
                                    {#if $sortStoreTable == "ID ASC"}
                                        <Table.Head class=" flex items-center bg-stone-100">ID <ChevronUp /> </Table.Head>
                                    {:else if $sortStoreTable == "ID DESC"}
                                        <Table.Head class=" flex items-center bg-stone-100">ID <ChevronDown/> </Table.Head>
                                    {:else}
                                        <Table.Head class="">ID</Table.Head>
                                    {/if}
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
                                    {#if $sortStoreTable == "ID ASC"}
                                        <Table.Head class=" flex items-center bg-stone-100">ID <ChevronUp /> </Table.Head>
                                    {:else if $sortStoreTable == "ID DESC"}
                                        <Table.Head class=" flex items-center bg-stone-100">ID <ChevronDown/> </Table.Head>
                                    {:else if $sortStoreTable == "Amount ASC"}
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
                                <Table.Head class=" text-right">More Details</Table.Head>
                            </Table.Row>
                        </Table.Header>
                        <Table.Body>
                            {#each invoiceList as invoice}
                            <Table.Row>
                                {#if innerWidth > 800}
                                    <Table.Cell class="font-medium">{invoice.transactionID}</Table.Cell>
                                    <Table.Cell>{invoice.transactionAmount.amountBTC} BTC</Table.Cell>
                                    <Table.Cell>{new Date(Number(BigInt(invoice.transactionDateTime)) / 1000000).toLocaleDateString('en-GB')}</Table.Cell>
                                    <Table.Cell>{invoice.transactionReceivers[0].benificiary.donation}</Table.Cell>
                                    <Table.Cell>{invoice.sourceBTCAddy}</Table.Cell>
                                {:else if innerWidth < 800}
                                    {#if $sortStoreTable == "ID ASC" || $sortStoreTable == "ID DESC"}
                                        <Table.Cell class="font-medium">{invoice.transactionID}</Table.Cell>
                                    {:else if $sortStoreTable == "Amount ASC" || $sortStoreTable == "Amount DESC"}
                                        <Table.Cell>{invoice.transactionAmount.amountBTC} BTC</Table.Cell>
                                    {:else if $sortStoreTable == "Recipient ASC" || $sortStoreTable == "Recipient DESC"}
                                        <Table.Cell>{invoice.transactionReceivers[0].benificiary.donation}</Table.Cell>
                                    {:else if $sortStoreTable == "Sender ASC" || $sortStoreTable == "Sender DESC"}
                                        <Table.Cell>{invoice.sourceBTCAddy}</Table.Cell>
                                    {/if}   
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
                            {#each invoiceList as invoice}
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