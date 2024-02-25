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
  export let viewMode : any;

  let clicked = false;
  let page1 = true;
  let page2 = false;
  let page3 = false;
  let page4 = false;

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

      const Currency : any  = {
        Bitcoin : {"bitcoin": null},
        Satoshi : {"satoshi": null},
        ProofOfConcept : {"proofOfConcept": null},
      }

      interface Amount {
          amount : number;
          currency : typeof Currency;
      }
      
      type Reciever = {
        amounts: [Amount];
        percentage: number;
        benificiary: string;
      };

      
      // @ts-ignore
      const parsedBTCAmount: number = parseFloat(numberInput);

      const roundedAmountInSatoshi: number = Math.round(parsedBTCAmount * 100000000);

      const amountArray : Amount[] = [
        {
          amount : parsedBTCAmount,
          currency : {"bitcoin": null}
        },
        {
          amount : roundedAmountInSatoshi,
          currency : {"satoshi": null}
        }
      ]
      
      const parsedPercentages = percentages.map(parseFloat);
      const totalPercentage = parsedPercentages.reduce((acc, val) => acc + val, 0);
      const slider1 = (numberInput * parsedPercentages[0]) / totalPercentage;
      const slider2 = (numberInput * parsedPercentages[1]) / totalPercentage;
      const slider3 = (numberInput * parsedPercentages[2]) / totalPercentage;
      const slider4 = (numberInput * parsedPercentages[3]) / totalPercentage;
      
      const receiverAmounts = parsedPercentages.map(percentage =>
        Math.round((percentage / totalPercentage) * Number(roundedAmountInSatoshi))
      );

      const receiverArray: Reciever[] = [
      {
        amounts: [{ amount: receiverAmounts[0], currency: {"satoshi": null} }],
        percentage: parsedPercentages[0],
        benificiary: "curriculum"
      },
      {
        amounts: [{ amount: slider1, currency: {"bitcoin": null} }],
        percentage: parsedPercentages[0],
        benificiary: "curriculum"
      },
      {
        amounts: [{ amount: receiverAmounts[1], currency: {"satoshi": null} }],
        percentage: parsedPercentages[1],
        benificiary: "teacher"
      },
      {
        amounts: [{ amount: slider2, currency: {"bitcoin": null} }],
        percentage: parsedPercentages[1],
        benificiary: "teacher"
      },
      {
        amounts: [{ amount: receiverAmounts[2], currency: {"satoshi": null} }],
        percentage: parsedPercentages[2],
        benificiary: "school"
      },
      {
        amounts: [{ amount: slider3, currency: {"bitcoin": null} }],
        percentage: parsedPercentages[2],
        benificiary: "school"
      },
      {
        amounts: [{ amount: receiverAmounts[3], currency: {"satoshi": null} }],
        percentage: parsedPercentages[3],
        benificiary: "lunch"
      },
      {
        amounts: [{ amount: slider4, currency: {"bitcoin": null} }],
        percentage: parsedPercentages[3],
        benificiary: "lunch"
      }
    ];

      await actor.storeBtcTransaction(transactionID, sourceBTCAddy, amountArray, receiverArray, entityID, bitcoinAddy);
      
      page2 = false;
      page3 = true;
      clicked = false;
		} catch (err: unknown) {
			page2 = false;
      page4 = true;
      clicked = false;
		}
  }

  let transactionID = '';
  let sourceBTCAddy = '';

  function handleInputTXID(event) {
    transactionID = event.target.value;
  }

  function handleInputsourceBTCAddy(event) {
    sourceBTCAddy = event.target.value;
  }

  let numberInput = 0;
  let sliders = [0, 0, 0, 0];
  $: percentages = sliders.map(value => {
    return numberInput > 0
      ? ((value / numberInput) * 100).toFixed(1) + "%"
      : "0.0$";
  });
  let sliderNames = [
    "Curriculum design and development",
    "Teacher support",
    "School supplies",
    "Lunch and snacks",
  ];

  $: sliderMaxValues = sliders.map((_, index) => {
    let sumExcludingCurrent = sliders.reduce(
      (acc, val, i) => acc + (i !== index ? val : 0),
      0
    );
    return numberInput - sumExcludingCurrent;
  });

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
    {#if viewMode == "card"}
      <Button
        builders={[builder]}
        variant="outline"
        class="mx-5 text-white hover:text-black hover:bg-stone-100  bg-transparent border-2 border-stone-50 font-semibold py-2 px-4 rounded"
        >Donate</Button
      >
    {:else}
      <Button
        builders={[builder]}
        variant="outline"
        class="mx-5 text-black dark:text-white hover:text-white hover:dark:text-black hover:bg-stone-900 hover:dark:bg-white bg-transparent font-semibold py-2 px-4 rounded"
        >Donate</Button
      >
    {/if}
  </Sheet.Trigger>
  <Sheet.Content class="{page3 ? 'bg-black text-white' : ''} {page4 ? 'bg-black text-white' : ''} {page1 ? 'text-black dark:text-white' : ''} {page2 ? 'text-black dark:text-white' : ''}" side="right" style="overflow: auto; max-width: 30rem;">
    <Sheet.Header>
    </Sheet.Header>
    <div class="grid grid-cols-12 col-span-12 justify-center items-center">
      <div class="hidden md:flex md:col-span-4"></div>
      <div class="col-span-12 md:col-span-4">
        {#if page1}
          <h4 class="mt-6 text-2xl font-semibold">{entity.name}</h4>
            <img
            src={entity.image}
            alt="Donation entity"
            class="donation-image rounded-lg mt-3 max-h-[600px] max-w-md mx-auto"
          />
          <p class="text-sm">{entity.story}</p>
          <div class="flex justify-between mt-6 mb-3 items-center">
            <p class="text-base">Amount Raised:</p>
            <h4
              class="text-base flex dark:bg-white dark:p-1 dark:rounded dark:text-black"
            >
              BTC {entity.raise}
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
                      class="flex text-sm dark:bg-white dark:p-1 dark:rounded dark:text-black"
                    >
                    <svg width="22" height="22" viewBox="0 0 128 128" fill="none" xmlns="http://www.w3.org/2000/svg">
                      <path d="M69.4498 101.067C96.1161 101.066 96.1191 63.7353 69.4519 63.7313M69.4498 101.067L37.4594 101.065M69.4498 101.067L69.457 111.734M48.1204 63.7342L69.4572 63.7304C96.1244 63.7344 96.1265 26.3988 69.455 26.401L37.4541 26.4005M69.4497 26.4019L69.4531 15.7326M48.114 111.734L48.1153 15.7311" stroke="black" stroke-width="8" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg>
                      {slider.toFixed(8)}
                    </span>
                  </div>
                </div>
                <input
                  type="range"
                  min="0"
                  style="accent-color: #000;"
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
            <div class="grid col-span-12 justify-center items-center text-center mt-20">
              <div class="col-span-12">
                <p class="font-bold text-2xl mb-5 text-white">Payment Received</p>
                <p class="font-bold text-2xl mb-5 text-white">You can view your transaction in the Donation Transaction Explorer</p>
                <div class="flex justify-center items-center w-full mt-10">
                  <svg width="350" height="350" viewBox="0 0 115 115" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M57.5 14.375C51.75 14.375 46 17.25 43.125 22.5208C40.2558 21.7862 37.2458 21.8028 34.3848 22.5689C31.5238 23.335 28.9083 24.8248 26.79 26.8949C24.6718 28.9649 23.1223 31.5455 22.2906 34.3882C21.459 37.2308 21.3733 40.2396 22.0417 43.125C17.25 46 13.8959 51.75 13.8959 57.5C13.8959 63.25 17.25 69 22.0417 71.875C20.6042 77.625 22.0417 83.8542 26.8334 88.1667C30.6667 92 36.8959 93.9167 42.6459 92.9583C45.5209 97.75 51.2709 100.625 57.0209 100.625C62.7709 100.625 68.5209 97.75 71.3959 92.4792C77.1459 93.9167 83.375 92.4792 87.6875 87.6875C91.5209 83.8542 93.4375 78.1042 92.4792 71.875C97.2709 69 100.146 63.25 100.146 57.5C100.146 51.75 97.2709 46 92 43.125C93.4375 37.375 92 31.1458 87.2084 26.8333C85.1598 24.8109 82.6495 23.3177 79.8944 22.4829C77.1394 21.648 74.2225 21.4966 71.3959 22.0417C68.5209 17.25 62.7709 14.375 57.0209 14.375H57.5Z" stroke="white" stroke-width="8" stroke-linecap="round" stroke-linejoin="round"/>
                    <path d="M43.125 57.5001L52.7083 67.0834L71.875 47.9167" stroke="white" stroke-width="8" stroke-linecap="round" stroke-linejoin="round"/>
                  </svg> 
                </div>
              </div>  
            </div>
          {:else if page4}
          <div class="grid col-span-12 justify-center items-center text-center mt-20">
            <div class="col-span-12">
              <p class="font-bold text-2xl mb-5 text-white">Error</p>
              <p class="font-bold text-2xl mb-5 text-white">An error occured. Please try again later.</p>
              <div class="flex justify-center items-center w-full mt-10">
                <svg width="370" height="370" viewBox="0 0 370 370" fill="none" xmlns="http://www.w3.org/2000/svg">
                  <path d="M186.944 10C163.611 10 140.278 21.6667 128.611 43.0556C116.968 40.0746 104.753 40.1418 93.1434 43.2505C81.5337 46.3593 70.9199 52.4049 62.3242 60.8052C53.7285 69.2056 47.4405 79.6776 44.0657 91.2128C40.6909 102.748 40.343 114.958 43.0556 126.667C23.6111 138.333 10 161.667 10 185C10 208.333 23.6111 231.667 43.0556 243.333C37.2222 266.667 43.0556 291.944 62.5 309.444C78.0556 325 103.333 332.778 126.667 328.889C138.333 348.333 161.667 360 185 360C208.333 360 231.667 348.333 243.333 326.944C266.667 332.778 291.944 326.944 309.444 307.5C325 291.944 332.778 268.611 328.889 243.333C348.333 231.667 360 208.333 360 185C360 161.667 348.333 138.333 326.944 126.667C332.778 103.333 326.944 78.0556 307.5 60.5556C299.187 52.3485 289 46.2893 277.82 42.9015C266.64 39.5137 254.804 38.8992 243.333 41.1111C231.667 21.6667 208.333 10 185 10H186.944Z" stroke="#DB4E66" stroke-width="20" stroke-linecap="round" stroke-linejoin="round"/>
                  <path d="M141.25 141.25L228.75 228.75" stroke="#DB4E66" stroke-width="20" stroke-linecap="round" stroke-linejoin="round"/>
                  <path d="M228.75 141.25L141.25 228.75" stroke="#DB4E66" stroke-width="20" stroke-linecap="round" stroke-linejoin="round"/>
                  <path d="M228.75 141.25L141.25 228.75" stroke="#DB4E66" stroke-width="20" stroke-linecap="round" stroke-linejoin="round"/>
                  <path d="M228.75 141.25L141.25 228.75" stroke="#DB4E66" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>  
              </div>
            </div>  
          </div>
        {/if}
      </div>
      <div class="hidden md:flex md:col-span-4"></div>
    </div>

  </Sheet.Content>
</Sheet.Root>

<style>
  .donation-image {
    width: 100%;
    height: auto;
    margin-bottom: 2rem;
    margin-top: 2rem;
  }
</style>