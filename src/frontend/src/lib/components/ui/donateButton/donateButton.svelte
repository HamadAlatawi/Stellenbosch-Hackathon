<script lang="ts">
  import * as Sheet from "../sheet";
  import { Button } from "../button";
  import { Input } from "$lib/components/ui/input";
  import { Label } from "$lib/components/ui/label";
  import { toast } from "svelte-sonner";
  import { Reload } from "radix-icons-svelte";
  import { qr } from '@svelte-put/qr/svg';
  import Bitcoin from '$lib/images/Bitcoin.webp'
  import { actorBackEnd, actorBackEndTransaction } from "$lib/motokoImports/backend"


  export let entity: any;

  let clicked = false;
  let page1 = true;
  let page2 = false;
  let page3 = false;

  let bitcoinAddy = "";

  const handleOnSubmit = async () => {
      clicked = true;
      await getBitcoinAddy();
      if(bitcoinAddy){
        page1 = false;
        page2 = true;
      }
      clicked = false;
  };

  const getBitcoinAddy = async () => {
		try {
			const actor = actorBackEnd;
			bitcoinAddy = await actor.get_p2pkh_address();
		} catch (err: unknown) {
			console.error(err);
		}
  }

  const createTransaction: (entityID: bigint) => Promise<void> = async (entityID: bigint) => {
    try {
      clicked = true;
			const actor = actorBackEndTransaction;

      interface Amount {
          amountInSatoshi: bigint;
          amountBTC: number;
      }
      
      // @ts-ignore
      const parsedBTCAmount: number = parseFloat(numberInput);

      const roundedAmountInSatoshi: bigint = BigInt(Math.round(parsedBTCAmount * 100000000));

      const amountArray: Amount = {
        amountInSatoshi: roundedAmountInSatoshi,
        amountBTC: parsedBTCAmount
      };
      

      const parsedPercentages = percentages.map(parseFloat);
      const totalPercentage = parsedPercentages.reduce((acc, val) => acc + val, 0);
      const slider1 = (numberInput * parsedPercentages[0]) / totalPercentage;
      const slider2 = (numberInput * parsedPercentages[1]) / totalPercentage;
      const slider3 = (numberInput * parsedPercentages[2]) / totalPercentage;
      const slider4 = (numberInput * parsedPercentages[3]) / totalPercentage;

      interface Beneficiary {
        donation: string;
      }

      type Reciever = {
        amount: Amount;
        percentage: number;
        benificiary: Beneficiary;
      };

      const receiverAmounts = parsedPercentages.map(percentage =>
        BigInt(Math.round((percentage / totalPercentage) * Number(roundedAmountInSatoshi)))
      );

      const receiverArray: Reciever[] = [
      {
        amount: { amountInSatoshi: receiverAmounts[0], amountBTC: slider1 },
        percentage: parsedPercentages[0],
        benificiary: { donation: "curriculum" }
      },
      {
        amount: { amountInSatoshi: receiverAmounts[1], amountBTC: slider2 },
        percentage: parsedPercentages[1],
        benificiary: { donation: "teacher" }
      },
      {
        amount: { amountInSatoshi: receiverAmounts[2], amountBTC: slider3 },
        percentage: parsedPercentages[2],
        benificiary: { donation: "school" }
      },
      {
        amount: { amountInSatoshi: receiverAmounts[3], amountBTC: slider4 },
        percentage: parsedPercentages[3],
        benificiary: { donation: "lunch" }
      }
    ];
      // @ts-ignore
      await actor.createAndAddTransaction(transactionID, sourceBTCAddy, amountArray, receiverArray, entityID);
      page2 = false;
      page3 = true;
      clicked = false;
		} catch (err: unknown) {
			console.error(err);
		}
  }

  let transactionID = '';
  let sourceBTCAddy = '';

  function handleInputTXID(event) {
    transactionID = event.target.value; // Update the transactionID variable
  }

  function handleInputsourceBTCAddy(event) {
    sourceBTCAddy = event.target.value; // Update the transactionID variable
  }

  let numberInput = 0;
  let sliders = [0, 0, 0, 0];
  $: percentages = sliders.map(value => {
    return numberInput > 0
      ? ((value / numberInput) * 100).toFixed(1)
      : "0.0";
  });
  let sliderNames = [
    "Curriculum design and development",
    "Teacher support",
    "School supplies",
    "Lunch and snacks",
  ];

  // $: totalSum = sliders.reduce((a, b) => a + b, 0);
  $: sliderMaxValues = sliders.map((_, index) => {
    let sumExcludingCurrent = sliders.reduce(
      (acc, val, i) => acc + (i !== index ? val : 0),
      0
    );
    return numberInput - sumExcludingCurrent;
  });

  // Assume Toaster has a static method to show toasts
  function updateSliders(index: number, value: number) {
    const newValue = value;
    if (newValue > sliderMaxValues[index]) {
      toast("Value exceeds maximum allowed.");
    } else {
      sliders[index] = newValue;
      numberInput > 0
      ? percentages[index] = ((value / numberInput) * 100).toFixed(1) + "%"
      : percentages[index] = 0.0 + "%";
    }
  }

  let checkboxChecked = false;
  let buttonDisabled = true;

  function handleCheckboxChange(event) {
    checkboxChecked = event.target.checked;
    if(bitcoinAddy && transactionID){
      buttonDisabled = !checkboxChecked;
    }
  }

</script>

<Sheet.Root>
  <Sheet.Trigger asChild let:builder>
    <Button
      builders={[builder]}
      variant="outline"
      class="mx-5 text-white bg-transparent hover:bg-stone-100 hover:text-black font-bold py-2 px-4 rounded"
      >Donate</Button
    >
  </Sheet.Trigger>
  <Sheet.Content class="{page3 ? 'bg-black' : ''}" side="right" style="overflow: auto; max-width: 30rem;">
    <Sheet.Header>
      <Sheet.Title class="{page3 ? 'hidden' : ''}">Donate</Sheet.Title>
    </Sheet.Header>
    {#if page1}
      <img
      src={entity.image}
      alt="Donation Image"
      class="donation-image rounded-lg mt-3"
    />
    <h4>{entity.name}</h4>
    <p class="text-sm">{entity.story}</p>
    <div class="flex justify-between mt-3 mb-3 items-center">
      <p class="text-xs">Amount Raised:</p>
      <h4
        class="text-base flex dark:bg-white dark:p-1 dark:rounded dark:text-black"
      >
        {entity.raise}
      </h4>
    </div>

    <h4 class="mt-10">Donate Now</h4>
    <p class="text-xs mb-3">
      Adjust the slider to choose the percentage of your donation allocated
      towards supporting the cause
    </p>

    <Input
      bind:value={numberInput}
      type="number"
      min="0.000000001"
      step="0.0001"
      style="padding-left: 32px; margin: 20px auto;"
    />
    <div class="mt-5 mb-5 rounded border-2 p-5">
      {#each sliders as slider, index (index)}
        <div class="border-0 border-b-2 border-white mb-5 light:border-black">
          <div class="text-sm">{sliderNames[index]}</div>
          <div class="pt-5 flex align-center justify-between">
            <div class="text-sm mb-3">{percentages[index]}</div>

            <div class="flex justify-between mb-3 items-center">
              <span
                class="text-base flex text-sm dark:bg-white dark:p-1 dark:rounded dark:text-black"
              >
                {slider.toFixed(8)}
              </span>
            </div>
          </div>
          <input
            type="range"
            min="0"
            max={sliderMaxValues[index]}
            step="any"
            value={slider}
            on:input={(event) => updateSliders(index, Number(event?.target?.value || sliderMaxValues[index]))}
            class="slider mb-5 w-full"
          />
        </div>
      {/each}
    </div>
    {#if !sliders.every(value => value === 0) && numberInput > 0}
      <div class="flex justify-end">
            {#if !clicked}
                <Button variant="outline" class="my-10 h-9 w-32" on:click={handleOnSubmit}>Donate</Button>
            {:else}
                <Button disabled class="my-10 h-9 w-32">
                    <Reload class="mr-2 h-4 w-4 animate-spin" />
                    Please wait
                </Button>
            {/if}
          </div>
    {/if}
    {:else if page2}
      <h4 class="font-bold mt-2 text-center lg:text-start">{entity.name}</h4>
      <div class="grid col-span-12 flex justify-center items-center text-center mt-10">
        <div class="col-span-12">
            <p class="font-bold mb-5">Pay with BTC</p>
            <svg
              use:qr={{
                data: bitcoinAddy,
                logo: Bitcoin,
                shape: 'circle',
              }}
            />
            <hr class="mt-5">
            <p class="text-xs px-4 mt-5">Bitcoin Address: {bitcoinAddy}</p>
            <p class="text-xs px-4 mt-10">Scan the QR code or send Bitcoin to the address provided above to contribute to our cause.</p>
            <p class="text-xs px-4 mt-10">Once you've sent the amount please provide us with your bitcoin address and the transaction ID and check the box to continue.</p>
        </div>
        <div class="col-span-12 flex justify-around items-center mt-3">
          <div class="grid w-full max-w-sm items-center gap-1.5">
            <Label class="text-start mt-5" for="Btc">BTC Address</Label>
            <Input type="text" id="Btc" placeholder="Your BTC Address" bind:value={sourceBTCAddy} on:input={handleInputsourceBTCAddy}/>
          </div>
        </div>
        <div class="col-span-12 flex justify-around items-center">
          <div class="grid w-full max-w-sm items-center gap-1.5">
            <Label class="text-start mt-5" for="txid">TXID</Label>
            <Input type="text" id="txid" placeholder="Transaction ID" bind:value={transactionID} on:input={handleInputTXID}/>
          </div>
        </div>
        <div class="col-span-12 flex justify-around items-center">
          <div class="">
            <label>
              <input type="checkbox" class="accent-stone-900" bind:checked={checkboxChecked} on:change={handleCheckboxChange} />
              I've sent a transaction
            </label>
          </div>
          <div>
            {#if !clicked}
                <Button variant="outline" class="my-10 h-9 w-32" disabled={buttonDisabled} on:click={() => createTransaction(BigInt(entity.id))}>Transferred</Button>
            {:else}
                <Button disabled class="my-10 h-9 w-32">
                    <Reload class="mr-2 h-4 w-4 animate-spin" />
                    Please wait
                </Button>
            {/if}
          </div>
        </div>
    </div>        
    {:else if page3}
    <div class="grid col-span-12 flex justify-center items-center text-center mt-20">
      <div class="col-span-12">
        <p class="font-bold text-2xl mb-5 text-white">Payment Received</p>
        <svg width="350" height="350" viewBox="0 0 115 115" fill="none" xmlns="http://www.w3.org/2000/svg">
          <path d="M57.5 14.375C51.75 14.375 46 17.25 43.125 22.5208C40.2558 21.7862 37.2458 21.8028 34.3848 22.5689C31.5238 23.335 28.9083 24.8248 26.79 26.8949C24.6718 28.9649 23.1223 31.5455 22.2906 34.3882C21.459 37.2308 21.3733 40.2396 22.0417 43.125C17.25 46 13.8959 51.75 13.8959 57.5C13.8959 63.25 17.25 69 22.0417 71.875C20.6042 77.625 22.0417 83.8542 26.8334 88.1667C30.6667 92 36.8959 93.9167 42.6459 92.9583C45.5209 97.75 51.2709 100.625 57.0209 100.625C62.7709 100.625 68.5209 97.75 71.3959 92.4792C77.1459 93.9167 83.375 92.4792 87.6875 87.6875C91.5209 83.8542 93.4375 78.1042 92.4792 71.875C97.2709 69 100.146 63.25 100.146 57.5C100.146 51.75 97.2709 46 92 43.125C93.4375 37.375 92 31.1458 87.2084 26.8333C85.1598 24.8109 82.6495 23.3177 79.8944 22.4829C77.1394 21.648 74.2225 21.4966 71.3959 22.0417C68.5209 17.25 62.7709 14.375 57.0209 14.375H57.5Z" stroke="white" stroke-width="8" stroke-linecap="round" stroke-linejoin="round"/>
          <path d="M43.125 57.5001L52.7083 67.0834L71.875 47.9167" stroke="white" stroke-width="8" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>          
      </div>  
    </div>
    {/if}
  </Sheet.Content>
</Sheet.Root>

<style>
  .donation-image {
    width: 100%; /* Adjust as needed */
    height: auto;
    margin-bottom: 1rem;
  }
</style>