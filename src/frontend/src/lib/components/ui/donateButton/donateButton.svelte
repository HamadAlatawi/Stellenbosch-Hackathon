<script lang="ts">
  import * as Sheet from "../sheet";
  import { Button } from "../button";
  import Slider from "$lib/slider/slider.svelte";
  import Input from "../input/input.svelte";
  import { toast } from "svelte-sonner";

  export let entity: any;

  function donate(event: MouseEvent) {
    event.preventDefault();
    console.log(`Donating to: ${entity.image}`);
  }

  let numberInput = 0.001;
  let sliders = [0, 0, 0, 0];
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
  function updateSliders(index: number, value: string) {
    const newValue = parseInt(value, 10);
    if (newValue > sliderMaxValues[index]) {
      toast("Value exceeds maximum allowed.");
    } else {
      sliders[index] = newValue;
    }
  }

  const calculatePercentage = (value: number) => {
    return numberInput > 0
      ? ((value / numberInput) * 100).toFixed(1) + "%"
      : "0%";
  };
</script>

<Sheet.Root>
  <Sheet.Trigger asChild let:builder>
    <Button
      on:click={donate}
      builders={[builder]}
      variant="outline"
      class="mx-5 bg-gray-700 text-white hover:bg-gray-900 hover:text-white font-bold py-2 px-4 rounded"
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
      <h4 class="text-base flex">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          viewBox="0 0 24 24"
          fill="currentColor"
          class="w-6 h-6 mx-1"
        >
          <path
            d="M21 6.375c0 2.692-4.03 4.875-9 4.875S3 9.067 3 6.375 7.03 1.5 12 1.5s9 2.183 9 4.875Z"
          />
          <path
            d="M12 12.75c2.685 0 5.19-.586 7.078-1.609a8.283 8.283 0 0 0 1.897-1.384c.016.121.025.244.025.368C21 12.817 16.97 15 12 15s-9-2.183-9-4.875c0-.124.009-.247.025-.368a8.285 8.285 0 0 0 1.897 1.384C6.809 12.164 9.315 12.75 12 12.75Z"
          />
          <path
            d="M12 16.5c2.685 0 5.19-.586 7.078-1.609a8.282 8.282 0 0 0 1.897-1.384c.016.121.025.244.025.368 0 2.692-4.03 4.875-9 4.875s-9-2.183-9-4.875c0-.124.009-.247.025-.368a8.284 8.284 0 0 0 1.897 1.384C6.809 15.914 9.315 16.5 12 16.5Z"
          />
          <path
            d="M12 20.25c2.685 0 5.19-.586 7.078-1.609a8.282 8.282 0 0 0 1.897-1.384c.016.121.025.244.025.368 0 2.692-4.03 4.875-9 4.875s-9-2.183-9-4.875c0-.124.009-.247.025-.368a8.284 8.284 0 0 0 1.897 1.384C6.809 19.664 9.315 20.25 12 20.25Z"
          />
        </svg>
        {entity.raise}
      </h4>
    </div>

    <h4 class="mt-3">Donate Now</h4>
    <p class="text-xs mb-3">Adjust the slider to choose the percentage of your donation allocated towards supporting the cause</p>

    <Input
      bind:value={numberInput}
      type="number"
      min="0.001"
      step="0.001"
      style="padding-left: 32px; margin: 10px auto;"
    />
    <div class="mt-5 mb-5">
      {#each sliders as slider, index (index)}
        <div class="slider-box">
          <div class="slider-header mb-3">
            <div class="slider-label">{sliderNames[index]}</div>
            <div class="slider-info">
              <span class="slider-percentage"
                >{calculatePercentage(slider)}</span
              >
              <span class="slider-amount">{slider.toFixed(4)} BTC</span>
            </div>
          </div>
          <Slider
            value={[slider]}
            min={0}
            max={sliderMaxValues[index]}
            on:change={(event) => updateSliders(index, event.detail)}
            step={0.001}
          />
          <!-- Conditional divider removed for brevity -->
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

  .slider-box {
    border: 1px solid #ddd;
    padding: 20px;
    border-radius: 8px;
    margin-bottom: 20px;
  }

  .slider-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 10px;
  }

  .slider-label {
    font-weight: bold;
  }

  .slider-info {
    text-align: right;
  }

  .slider-percentage {
    margin-right: 15px;
  }
</style>
