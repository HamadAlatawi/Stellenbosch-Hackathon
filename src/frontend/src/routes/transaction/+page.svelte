<script lang="ts">
    import { onMount } from 'svelte';
    import { Button } from "$lib/components/ui/button";
    import * as Table from "$lib/components/ui/table";
    import * as Pagination from "$lib/components/ui/pagination";
    import Skeleton from '$lib/components/ui/skeleton/skeleton.svelte';
    import * as Drawer from "$lib/components/ui/drawer";

    let showSkeleton = true;
    

    let invoices = [
        { invoiceNumber: 'INV001', status: 'Paid', method: 'Credit Card', amount: '$250.00' },
        { invoiceNumber: 'INV002', status: 'Pending', method: 'PayPal', amount: '$150.00' },
        { invoiceNumber: 'INV003', status: 'Unpaid', method: 'Bank Transfer', amount: '$350.00' },
        { invoiceNumber: 'INV004', status: 'Paid', method: 'Credit Card', amount: '$450.00' },
        { invoiceNumber: 'INV005', status: 'Paid', method: 'PayPal', amount: '$550.00' },
        { invoiceNumber: 'INV006', status: 'Pending', method: 'Bank Transfer', amount: '$200.00' },
        { invoiceNumber: 'INV007', status: 'Unpaid', method: 'Credit Card', amount: '$300.00' },
        { invoiceNumber: 'INV008', status: 'Paid', method: 'Bank Transfer', amount: '$700.00' },
        { invoiceNumber: 'INV009', status: 'Pending', method: 'Credit Card', amount: '$800.00' },
        { invoiceNumber: 'INV010', status: 'Unpaid', method: 'PayPal', amount: '$900.00' },
        { invoiceNumber: 'INV011', status: 'Paid', method: 'Bank Transfer', amount: '$1000.00' },
        { invoiceNumber: 'INV012', status: 'Pending', method: 'Credit Card', amount: '$1100.00' },
        { invoiceNumber: 'INV013', status: 'Unpaid', method: 'PayPal', amount: '$1200.00' },
        { invoiceNumber: 'INV014', status: 'Paid', method: 'Bank Transfer', amount: '$1300.00' },
        { invoiceNumber: 'INV015', status: 'Pending', method: 'Credit Card', amount: '$1400.00' },
        { invoiceNumber: 'INV016', status: 'Unpaid', method: 'PayPal', amount: '$1500.00' },
        { invoiceNumber: 'INV017', status: 'Paid', method: 'Bank Transfer', amount: '$1600.00' },
        { invoiceNumber: 'INV018', status: 'Pending', method: 'Credit Card', amount: '$1700.00' },
        { invoiceNumber: 'INV019', status: 'Unpaid', method: 'PayPal', amount: '$1800.00' },
        { invoiceNumber: 'INV020', status: 'Paid', method: 'Bank Transfer', amount: '$1900.00' }
    ];


    
    onMount(() => {
        setTimeout(() => {
            showSkeleton = false;
        }, 2000);
    });
</script>

<section class="grid grid-cols-12 flex justify-center items-center h-screen w-full">
    {#if showSkeleton}
        <div class="col-span-3"></div>
        <div class="col-span-6">
            <Table.Root>
                <Table.Caption>A list of transactions</Table.Caption>
                <Table.Header>
                    <Table.Row>
                        <Table.Head class="w-1/5">Invoice</Table.Head>
                        <Table.Head class="w-1/5">Status</Table.Head>
                        <Table.Head class="w-1/5">Method</Table.Head>
                        <Table.Head class="w-1/5">Amount</Table.Head>
                        <Table.Head class="w-1/5 text-right">Transaction Details</Table.Head>
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
                            <Table.Cell>
                                <Skeleton class="w-[60%] h-[27px]" />
                            </Table.Cell>
                            <Table.Cell>
                                <Skeleton class="w-[45%] h-[27px]" />
                            </Table.Cell>
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
        <div class="col-span-3"></div>
    {:else}
        <div class="col-span-3"></div>
        <div class="col-span-6">
            <Table.Root>
                <Table.Caption>A list of transactions</Table.Caption>
                <Table.Header>
                    <Table.Row>
                        <Table.Head class="w-1/5">Invoice</Table.Head>
                        <Table.Head class="w-1/5">Status</Table.Head>
                        <Table.Head class="w-1/5">Method</Table.Head>
                        <Table.Head class="w-1/5">Amount</Table.Head>
                        <Table.Head class="w-1/5 text-right">Transaction Details</Table.Head>
                    </Table.Row>
                </Table.Header>
                <Table.Body>
                    {#each invoices as invoice}
                        <Table.Row>
                            <Table.Cell class="font-medium">{invoice.invoiceNumber}</Table.Cell>
                            <Table.Cell>{invoice.status}</Table.Cell>
                            <Table.Cell>{invoice.method}</Table.Cell>
                            <Table.Cell>{invoice.amount}</Table.Cell>
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
        <div class="col-span-3"></div>
    {/if}
</section>
  