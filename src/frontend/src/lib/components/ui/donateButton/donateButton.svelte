<script lang="ts">
  import * as Sheet from "../sheet";
  import { Button } from "../button";
  import Slider from "$lib/slider/slider.svelte";
  import Input from "../input/input.svelte";
  import { toast } from "svelte-sonner";

  export let entity: any;

  let numberInput = 0.001;
  let sliders = [0, 0, 0, 0];
  $: percentages = sliders.map(value => {
    return numberInput > 0
      ? ((value / numberInput) * 100).toFixed(1) + "%"
      : "0.0%";
  });
  let sliderNames = [
    "Backing the Token",
    "Teacher Education and Support",
    "Development and Future Work",
    "Infrastructure",
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

</script>

<Sheet.Root>
  <Sheet.Trigger asChild let:builder>
    <Button
      builders={[builder]}
      variant="outline"
      class="mx-5 bg-stone-800 text-white hover:bg-stone-900 hover:text-white font-bold py-2 px-4 rounded"
      >Donate</Button
    >
  </Sheet.Trigger>
  <Sheet.Content side="right" style="overflow: auto; max-width: 30rem;">
    <Sheet.Header>
      <Sheet.Title>Donate</Sheet.Title>
    </Sheet.Header>
    <!-- svelte-ignore a11y-img-redundant-alt -->
    <img
      src={entity.image ||
        "https://www.google.com/url?sa=i&url=https%3A%2F%2Fstock.adobe.com%2Fsearch%3Fk%3Dperson&psig=AOvVaw08AqwGaHwVbtOKCkCxYa38&ust=1707054467295000&source=images&cd=vfe&opi=89978449&ved=0CBMQjRxqFwoTCKjn0Munj4QDFQAAAAAdAAAAABAE"}
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
        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 320 512"
          class="w-6 h-6 mr-1"
        >
          <path
            d="M48 32C48 14.3 62.3 0 80 0s32 14.3 32 32V64h32V32c0-17.7 14.3-32 32-32s32 14.3 32 32V64c0 1.5-.1 3.1-.3 4.5C254.1 82.2 288 125.1 288 176c0 24.2-7.7 46.6-20.7 64.9c31.7 19.8 52.7 55 52.7 95.1c0 61.9-50.1 112-112 112v32c0 17.7-14.3 32-32 32s-32-14.3-32-32V448H112v32c0 17.7-14.3 32-32 32s-32-14.3-32-32V448H41.7C18.7 448 0 429.3 0 406.3V288 265.7 224 101.6C0 80.8 16.8 64 37.6 64H48V32zM64 224H176c26.5 0 48-21.5 48-48s-21.5-48-48-48H64v96zm112 64H64v96H208c26.5 0 48-21.5 48-48s-21.5-48-48-48H176z"
          /></svg
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
      min="0.001"
      step="0.001"
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
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 320 512"
                  class="w-6 h-6 mr-1"
                >
                  <path
                    d="M48 32C48 14.3 62.3 0 80 0s32 14.3 32 32V64h32V32c0-17.7 14.3-32 32-32s32 14.3 32 32V64c0 1.5-.1 3.1-.3 4.5C254.1 82.2 288 125.1 288 176c0 24.2-7.7 46.6-20.7 64.9c31.7 19.8 52.7 55 52.7 95.1c0 61.9-50.1 112-112 112v32c0 17.7-14.3 32-32 32s-32-14.3-32-32V448H112v32c0 17.7-14.3 32-32 32s-32-14.3-32-32V448H41.7C18.7 448 0 429.3 0 406.3V288 265.7 224 101.6C0 80.8 16.8 64 37.6 64H48V32zM64 224H176c26.5 0 48-21.5 48-48s-21.5-48-48-48H64v96zm112 64H64v96H208c26.5 0 48-21.5 48-48s-21.5-48-48-48H176z"
                  /></svg
                >
                {slider.toFixed(8)}
              </span>
            </div>
          </div>
          <input
            type="range"
            min="0"
            max={sliderMaxValues[index]}
            step="0.001"
            value={slider}
            on:input={(event) => updateSliders(index, Number(event?.target?.value || sliderMaxValues[index]))}
            class="slider mb-5 w-full"
          />
        </div>
      {/each}
    </div>
    <Button>Donate</Button>
  </Sheet.Content>
</Sheet.Root>

<style>
  .donation-image {
    width: 100%; /* Adjust as needed */
    height: auto;
    margin-bottom: 1rem;
  }
</style>
