<script lang="ts">
    import { onMount } from 'svelte';
    import { Button } from "$lib/components/ui/button";
    import * as Table from "$lib/components/ui/table";
    import * as Pagination from "$lib/components/ui/pagination";
    import Skeleton from '$lib/components/ui/skeleton/skeleton.svelte';
    import * as Drawer from "$lib/components/ui/drawer";
    import { Input } from "$lib/components/ui/input";
    import * as DropdownMenu from "$lib/components/ui/dropdown-menu";

    let showSkeleton = true;
    let innerWidth : any;

    let invoices = [
    { 
        invoiceNumber: 'INV001', 
        amount: '$250.00', 
        date: '01/15/24', 
        recipient: 'John Doe', 
        sender: 'Jane Smith', 
        country: 'USA' 
    },
    { 
        invoiceNumber: 'INV002', 
        amount: '$150.00', 
        date: '01/16/24', 
        recipient: 'Alice Johnson', 
        sender: 'Bob Brown', 
        country: 'Canada' 
    },
    { 
        invoiceNumber: 'INV003', 
        amount: '$350.00', 
        date: '01/17/24', 
        recipient: 'Michael Davis', 
        sender: 'Emily Wilson', 
        country: 'UK' 
    },
    { 
        invoiceNumber: 'INV004', 
        amount: '$450.00', 
        date: '01/18/24', 
        recipient: 'Samantha Clark', 
        sender: 'Daniel Taylor', 
        country: 'Australia' 
    },
    { 
        invoiceNumber: 'INV005', 
        amount: '$550.00', 
        date: '01/19/24', 
        recipient: 'Ethan Martinez', 
        sender: 'Olivia Brown', 
        country: 'Germany' 
    },
    { 
        invoiceNumber: 'INV006', 
        amount: '$200.00', 
        date: '01/20/24', 
        recipient: 'Sophia Anderson', 
        sender: 'Matthew Thompson', 
        country: 'France' 
    },
    { 
        invoiceNumber: 'INV007', 
        amount: '$300.00', 
        date: '01/21/24', 
        recipient: 'William Rodriguez', 
        sender: 'Ava White', 
        country: 'Spain' 
    },
    { 
        invoiceNumber: 'INV008', 
        amount: '$700.00', 
        date: '01/22/24', 
        recipient: 'Emma Harris', 
        sender: 'James Martin', 
        country: 'Italy' 
    },
    { 
        invoiceNumber: 'INV009', 
        amount: '$800.00', 
        date: '01/23/24', 
        recipient: 'Noah Garcia', 
        sender: 'Isabella Garcia', 
        country: 'Brazil' 
    },
    { 
        invoiceNumber: 'INV010', 
        amount: '$900.00', 
        date: '01/24/24', 
        recipient: 'Mia Moore', 
        sender: 'Liam Clark', 
        country: 'China' 
    },
    { 
        invoiceNumber: 'INV011', 
        amount: '$1000.00', 
        date: '01/25/24', 
        recipient: 'Benjamin Jackson', 
        sender: 'Charlotte Anderson', 
        country: 'India' 
    },
    { 
        invoiceNumber: 'INV012', 
        amount: '$1100.00', 
        date: '01/26/24', 
        recipient: 'Harper Lee', 
        sender: 'Elijah Scott', 
        country: 'Japan' 
    },
    { 
        invoiceNumber: 'INV013', 
        amount: '$1200.00', 
        date: '01/27/24', 
        recipient: 'Amelia Martinez', 
        sender: 'Logan Green', 
        country: 'Russia' 
    },
    { 
        invoiceNumber: 'INV014', 
        amount: '$1300.00', 
        date: '01/28/24', 
        recipient: 'Evelyn Walker', 
        sender: 'Lucas Perez', 
        country: 'South Africa' 
    },
    { 
        invoiceNumber: 'INV015', 
        amount: '$1400.00', 
        date: '01/29/24', 
        recipient: 'Avery Evans', 
        sender: 'Zoe King', 
        country: 'Mexico' 
    },
    { 
        invoiceNumber: 'INV016', 
        amount: '$1500.00', 
        date: '01/30/24', 
        recipient: 'Nora White', 
        sender: 'Gabriel Rivera', 
        country: 'Argentina' 
    },
    { 
        invoiceNumber: 'INV017', 
        amount: '$1600.00', 
        date: '01/31/24', 
        recipient: 'Riley Hughes', 
        sender: 'Madison Scott', 
        country: 'Netherlands' 
    },
    { 
        invoiceNumber: 'INV018', 
        amount: '$1700.00', 
        date: '02/01/24', 
        recipient: 'Carter Wright', 
        sender: 'Hannah Nelson', 
        country: 'Sweden' 
    },
    { 
        invoiceNumber: 'INV019', 
        amount: '$1800.00', 
        date: '02/02/24', 
        recipient: 'Ella Brown', 
        sender: 'David Turner', 
        country: 'Switzerland' 
    },
    { 
        invoiceNumber: 'INV020', 
        amount: '$1900.00', 
        date: '02/03/24', 
        recipient: 'Jackson Baker', 
        sender: 'Victoria Carter', 
        country: 'Norway' 
    }
];

    let position = "";
    
    onMount(() => {
        setTimeout(() => {
            showSkeleton = false;
        }, 2000);
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


<section class="grid grid-cols-12 flex justify-center items-center h-screen w-full mt-10">
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
                            <Table.Head class="w-1/10">Country</Table.Head>
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
                                    <Skeleton class="w-[60%] h-[27px]" />
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
                            <Table.Head class="w-1/10">Country</Table.Head>
                        {/if}
                        <Table.Head class="w-1/5 text-right">More Details</Table.Head>
                    </Table.Row>
                </Table.Header>
                <Table.Body>
                    {#each invoices as invoice}
                        <Table.Row>
                            <Table.Cell class="font-medium">{invoice.invoiceNumber}</Table.Cell>
                            <Table.Cell>{invoice.amount}</Table.Cell>
                            {#if innerWidth > 800}
                                <Table.Cell>{invoice.date}</Table.Cell>
                                <Table.Cell>{invoice.recipient}</Table.Cell>
                                <Table.Cell>{invoice.sender}</Table.Cell>
                                <Table.Cell>{invoice.country}</Table.Cell>
                            {/if}
                            <Table.Cell class="text-right">
                                <Drawer.Root>
                                    <Drawer.Trigger asChild let:builder>
                                      <Button builders={[builder]} variant="outline" class="h-7">View Details</Button>
                                    </Drawer.Trigger>
                                    <Drawer.Content>
                                      <div class="mx-auto w-full max-w-sm">
                                        <Drawer.Header>
                                          <Drawer.Title>Transaction: {invoice.invoiceNumber}</Drawer.Title>
                                          <Drawer.Description>Transaction Status: {invoice.status}</Drawer.Description>
                                          <Drawer.Description>Transaction Status: {invoice.method}</Drawer.Description>
                                          <Drawer.Description>Transaction Status: {invoice.amount}</Drawer.Description>
                                        </Drawer.Header>
                                        <div class="grid grid-cols-12 p-4 pb-0 w-full">
                                            <div class="col-span-12 w-full">sdfg2134sdf</div>
                                        </div>
                                        <Drawer.Footer>
                                          <Button>Submit</Button>
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
  