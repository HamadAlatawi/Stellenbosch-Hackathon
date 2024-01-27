<script lang="ts">
    import { onMount } from 'svelte';
    import * as Table from "$lib/components/ui/table";
    import * as Pagination from "$lib/components/ui/pagination";
    import Skeleton from '$lib/components/ui/skeleton/skeleton.svelte';

    let showSkeleton = true;

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
                        <Table.Head class="w-[100px]">Invoice</Table.Head>
                        <Table.Head>Status</Table.Head>
                        <Table.Head>Method</Table.Head>
                        <Table.Head class="text-right">Amount</Table.Head>
                    </Table.Row>
                </Table.Header>
                <Table.Body>
                    {#each Array.from({ length: 20 }, (_, i) => i) as index}
                        <Table.Row>
                            <Table.Cell class="font-medium">
                                <Skeleton class="w-[50px] h-[20px]" />
                            </Table.Cell>
                            <Table.Cell>
                                <Skeleton class="w-[60px] h-[20px]" />
                            </Table.Cell>
                            <Table.Cell>
                                <Skeleton class="w-[100px] h-[20px]" />
                            </Table.Cell>
                            <Table.Cell class="flex justify-end items-end">
                                <Skeleton class="w-[60px] h-[20px]" />
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
                    <Table.Head class="w-[100px]">Invoice</Table.Head>
                    <Table.Head>Status</Table.Head>
                    <Table.Head>Method</Table.Head>
                    <Table.Head class="text-right">Amount</Table.Head>
                </Table.Row>
                </Table.Header>
                <Table.Body>
                <Table.Row>
                    <Table.Cell class="font-medium">INV001</Table.Cell>
                    <Table.Cell>Paid</Table.Cell>
                    <Table.Cell>Credit Card</Table.Cell>
                    <Table.Cell class="text-right">$250.00</Table.Cell>
                </Table.Row>
                <Table.Row>
                    <Table.Cell class="font-medium">INV002</Table.Cell>
                    <Table.Cell>Pending</Table.Cell>
                    <Table.Cell>PayPal</Table.Cell>
                    <Table.Cell class="text-right">$150.00</Table.Cell>
                </Table.Row>
                <Table.Row>
                    <Table.Cell class="font-medium">INV003</Table.Cell>
                    <Table.Cell>Unpaid</Table.Cell>
                    <Table.Cell>Bank Transfer</Table.Cell>
                    <Table.Cell class="text-right">$350.00</Table.Cell>
                </Table.Row>
                <Table.Row>
                    <Table.Cell class="font-medium">INV004</Table.Cell>
                    <Table.Cell>Paid</Table.Cell>
                    <Table.Cell>Credit Card</Table.Cell>
                    <Table.Cell class="text-right">$450.00</Table.Cell>
                </Table.Row>
                <Table.Row>
                    <Table.Cell class="font-medium">INV005</Table.Cell>
                    <Table.Cell>Paid</Table.Cell>
                    <Table.Cell>PayPal</Table.Cell>
                    <Table.Cell class="text-right">$550.00</Table.Cell>
                </Table.Row>
                <Table.Row>
                    <Table.Cell class="font-medium">INV006</Table.Cell>
                    <Table.Cell>Pending</Table.Cell>
                    <Table.Cell>Bank Transfer</Table.Cell>
                    <Table.Cell class="text-right">$200.00</Table.Cell>
                </Table.Row>
                <Table.Row>
                    <Table.Cell class="font-medium">INV007</Table.Cell>
                    <Table.Cell>Unpaid</Table.Cell>
                    <Table.Cell>Credit Card</Table.Cell>
                    <Table.Cell class="text-right">$300.00</Table.Cell>
                </Table.Row>
                <Table.Row>
                    <Table.Cell class="font-medium">INV008</Table.Cell>
                    <Table.Cell>Paid</Table.Cell>
                    <Table.Cell>Bank Transfer</Table.Cell>
                    <Table.Cell class="text-right">$700.00</Table.Cell>
                </Table.Row>
                <Table.Row>
                    <Table.Cell class="font-medium">INV009</Table.Cell>
                    <Table.Cell>Pending</Table.Cell>
                    <Table.Cell>Credit Card</Table.Cell>
                    <Table.Cell class="text-right">$800.00</Table.Cell>
                </Table.Row>
                <Table.Row>
                    <Table.Cell class="font-medium">INV010</Table.Cell>
                    <Table.Cell>Unpaid</Table.Cell>
                    <Table.Cell>PayPal</Table.Cell>
                    <Table.Cell class="text-right">$900.00</Table.Cell>
                </Table.Row>
                <Table.Row>
                    <Table.Cell class="font-medium">INV011</Table.Cell>
                    <Table.Cell>Paid</Table.Cell>
                    <Table.Cell>Bank Transfer</Table.Cell>
                    <Table.Cell class="text-right">$1000.00</Table.Cell>
                </Table.Row>
                <Table.Row>
                    <Table.Cell class="font-medium">INV012</Table.Cell>
                    <Table.Cell>Pending</Table.Cell>
                    <Table.Cell>Credit Card</Table.Cell>
                    <Table.Cell class="text-right">$1100.00</Table.Cell>
                </Table.Row>
                <Table.Row>
                    <Table.Cell class="font-medium">INV013</Table.Cell>
                    <Table.Cell>Unpaid</Table.Cell>
                    <Table.Cell>PayPal</Table.Cell>
                    <Table.Cell class="text-right">$1200.00</Table.Cell>
                </Table.Row>
                <Table.Row>
                    <Table.Cell class="font-medium">INV014</Table.Cell>
                    <Table.Cell>Paid</Table.Cell>
                    <Table.Cell>Bank Transfer</Table.Cell>
                    <Table.Cell class="text-right">$1300.00</Table.Cell>
                </Table.Row>
                <Table.Row>
                    <Table.Cell class="font-medium">INV015</Table.Cell>
                    <Table.Cell>Pending</Table.Cell>
                    <Table.Cell>Credit Card</Table.Cell>
                    <Table.Cell class="text-right">$1400.00</Table.Cell>
                </Table.Row>
                <Table.Row>
                    <Table.Cell class="font-medium">INV016</Table.Cell>
                    <Table.Cell>Unpaid</Table.Cell>
                    <Table.Cell>PayPal</Table.Cell>
                    <Table.Cell class="text-right">$1500.00</Table.Cell>
                </Table.Row>
                <Table.Row>
                    <Table.Cell class="font-medium">INV017</Table.Cell>
                    <Table.Cell>Paid</Table.Cell>
                    <Table.Cell>Bank Transfer</Table.Cell>
                    <Table.Cell class="text-right">$1600.00</Table.Cell>
                </Table.Row>
                <Table.Row>
                    <Table.Cell class="font-medium">INV018</Table.Cell>
                    <Table.Cell>Pending</Table.Cell>
                    <Table.Cell>Credit Card</Table.Cell>
                    <Table.Cell class="text-right">$1700.00</Table.Cell>
                </Table.Row>
                <Table.Row>
                    <Table.Cell class="font-medium">INV019</Table.Cell>
                    <Table.Cell>Unpaid</Table.Cell>
                    <Table.Cell>PayPal</Table.Cell>
                    <Table.Cell class="text-right">$1800.00</Table.Cell>
                </Table.Row>
                <Table.Row>
                    <Table.Cell class="font-medium">INV020</Table.Cell>
                    <Table.Cell>Paid</Table.Cell>
                    <Table.Cell>Bank Transfer</Table.Cell>
                    <Table.Cell class="text-right">$1900.00</Table.Cell>
                </Table.Row>
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
  