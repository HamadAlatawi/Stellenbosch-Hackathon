<script lang="ts">
    import { Button } from "$lib/components/ui/button";
	import { Person } from "radix-icons-svelte"
	import LPImageDesktop from '$lib/images/LandingImageDesktop.webp'
    import LPImageMobile from '$lib/images/LandingImageMobile.webp'
	import { mode } from "mode-watcher";
	import LPImageDesktop2 from "$lib/images/LandingPage2Desktop.webp";
	import LPImageMobile2 from "$lib/images/LandingPage2Mobile.webp";
	import EntitiesComponent from "$lib/components/ui/entityPage/EntitiesComponent.svelte";
	import TransactionComponent from "$lib/components/ui/transactionPage/TransactionComponent.svelte";


	let svgMode = $mode === "light" ? "white" : "black";

	$: {
        svgMode = $mode === "light" ? "white" : "black";
    }

	function scrollIntoView(target : string) {
		const el = document.querySelector(target);
		if (!el) return;
		el.scrollIntoView({
		behavior: 'smooth'
		});
  	}
</script>

<svelte:head>
	<title>Home - Donation Engine</title>
	<meta name="description" content="Donation Engine Home Page" />
</svelte:head>

<main class="pt-20 grid grid-cols-12 min-h-screen w-full justify-center" id="homeSection">
    <section class="col-span-12 grid grid-cols-12 gap-4 ">
		<div class="col-span-12 lg:col-span-6 px-5 md:px-20 lg:px-20 flex flex-col justify-center">
			<div class="lg:text-left">
				<h1 class="text-5xl mb-5 lg:mb-2 font-bold md:text-7xl lg:text-6xl xl:text-7xl text-center lg:text-start">EMPOWER THROUGH DONATIONS</h1>
			</div>
			<div class="lg:text-left text-center md:text-lg">
				<p>
					Join us in our mission to drive meaningful change worldwide. Your donation directly impacts lives, creating opportunities and transforming communities. Take action now to make a difference!
				</p>
			</div>
			<div class="flex justify-center lg:justify-start font-bold my-10">
				<Button class="text-xl py-5 lg:py-6 px-5 sm:px-16 md:px-16 xl:px-20 mr-2" on:click={
					() => {
						scrollIntoView("#donateSection")
					}
				}>Donate</Button>
				<Button class="text-xl py-5 lg:py-6 px-5 sm:px-16 md:px-16 xl:px-20" variant="ghost"on:click={
					() => {
						scrollIntoView("#impactSection")
					}
				}>Learn More</Button>
			</div>
		</div>			
		<div class="col-span-2 lg:hidden"></div>
        <div class="col-span-10 lg:col-span-6 mt-9 lg:mt-0 rounded-tl-[8rem] bg-stone-900 dark:bg-white pt-12 pl-12">
			<div class="border inset-0 bottom-0 border-stone-300 bg-stone-300 dark:border-stone-800 dark:bg-stone-800 border-t-8 border-l-8 rounded-tl-[5rem]">
				<picture>
                	<source media="(min-width: 768px)" srcset="{LPImageDesktop}" />
                	<img src="{LPImageMobile}" alt="entity" class="w-full h-full object-cover rounded-tl-[4.5rem]"/>
            	</picture>
			</div>
        </div>
    </section>
	<section class="col-span-12 grid grid-cols-12 gap-4 mt-16 lg:mt-28">
		<div class="grid grid-cols-12 w-full col-span-12 mb-16">
			<div class="col-span-1"></div>
			<div class="col-span-10 text-4xl mb-5 font-bold md:text-5xl lg:text-4xl xl:text-5xl text-center">Three Simple Steps to Change Lives</div>
			<div class="col-span-1"></div>
			<div class="col-span-1"></div>
			<div class="col-span-10 md:text-lg text-center">Follow these straightforward steps to play your part in making the world a better place, effortlessly!</div>
			<div class="col-span-1"></div>
		</div>
		<div class="grid grid-cols-12 w-full col-span-12 place-items-center mb-20">
			<div class="col-span-12 lg:col-span-4 lg:flex xl:px-28">
				<div class="text-center mb-10 mx-auto">
					<div class="w-28 h-28 bg-stone-800 dark:bg-stone-100 rounded-3xl flex justify-center items-center mb-5 mx-auto">
						<Person class="h-[54px] w-[54px] text-white dark:text-black" />
					</div>
					<p class="font-semibold text-2xl mb-5">Choose an Entity</p>
					<p class="text-pretty px-6">Select the cause or project you'd like to support from our list of impactful initiatives.</p>
				</div>
			</div>
			<div class="col-span-12 lg:col-span-4 lg:flex xl:px-16">
				<div class="text-center mb-10 mx-auto">
					<div class="w-28 h-28 bg-stone-800 dark:bg-stone-100  rounded-3xl flex justify-center items-center mb-5 mx-auto">
						<svg width="64" height="64" viewBox="0 0 128 128" fill="none" xmlns="http://www.w3.org/2000/svg">
							<path d="M69.4498 101.067C96.1161 101.066 96.1191 63.7353 69.4519 63.7313M69.4498 101.067L37.4594 101.065M69.4498 101.067L69.457 111.734M48.1204 63.7342L69.4572 63.7304C96.1244 63.7344 96.1265 26.3988 69.455 26.401L37.4541 26.4005M69.4497 26.4019L69.4531 15.7326M48.114 111.734L48.1153 15.7311" stroke="{svgMode}" stroke-width="8" stroke-linecap="round" stroke-linejoin="round"/>
						</svg>							
					</div>
					<p class="font-semibold text-2xl mb-5">Donate</p>
					<p class="text-pretty px-6">Make your contribution securely and conveniently through our donation platform, knowing that every penny goes towards creating positive change.</p>
				</div>
			</div>
			<div class="col-span-12 lg:col-span-4 lg:flex xl:px-28">
				<div class="text-center mb-10 mx-auto">
					<div class="w-28 h-28 bg-stone-800 dark:bg-stone-100  rounded-3xl flex justify-center items-center mb-5 mx-auto">
						<svg width="64" height="64" viewBox="0 0 128 128" fill="none" xmlns="http://www.w3.org/2000/svg">
							<path d="M117.333 59.0934V64.0001C117.327 75.501 113.603 86.6917 106.716 95.9032C99.8302 105.115 90.1508 111.853 79.1219 115.114C68.0929 118.375 56.3053 117.984 45.5171 113.998C34.7289 110.012 25.5181 102.646 19.2584 92.9978C12.9987 83.3496 10.0255 71.9364 10.7822 60.4604C11.539 48.9844 15.9851 38.0605 23.4575 29.3178C30.9298 20.5751 41.0281 14.4821 52.2463 11.9475C63.4645 9.41294 75.2014 10.5726 85.7067 15.2534" stroke="{svgMode}" stroke-width="8" stroke-linecap="round" stroke-linejoin="round"/>
							<path d="M117.333 21.3335L64 74.7202L48 58.7202" stroke="{svgMode}" stroke-width="8" stroke-linecap="round" stroke-linejoin="round"/>
						</svg>							
					</div>
					<p class="font-semibold text-2xl mb-5">Transaction</p>
					<p class="text-pretty px-6">Select the cause or project you'd like to support from our list of impactful initiatives.</p>
				</div>
			</div>
		</div>
	</section>
	<section class="col-span-12 bg-stone-100grid grid-cols-12 gap-4 border-y-stone-500 dark:border-y-stone-100 border-y-8" id="donateSection">
		<div class="grid grid-cols-12 w-full col-span-12 my-16">
			<div class="col-span-1"></div>
			<div class="col-span-10 text-4xl mb-2 font-bold md:text-5xl lg:text-4xl xl:text-5xl text-center">Meet the Hopeful</div>
			<div class="col-span-1"></div>
			<div class="col-span-1"></div>
			<div class="col-span-10 text-2xl mb-12 md:text-3xl lg:text-2xl xl:text-3xl text-center">Supporting the Students and Schools</div>
			<div class="col-span-1"></div>
			<div class="col-span-1 lg:col-span-4"></div>
			<div class="col-span-10 lg:col-span-4 md:text-lg text-center font-medium">Get acquainted with the hopeful faces of students and the nurturing environments of schools as we highlight those in need of your generous support.</div>
			<div class="col-span-1 lg:col-span-4"></div>
			<div class="hidden lg:flex lg:col-span-1"></div>
			<div class="col-span-1 lg:hidden"></div>
			<div class="col-span-10 lg:col-span-10 ">
				<EntitiesComponent />
			</div>
			<div class="col-span-1 lg:hidden"></div>
		</div>
	</section>
	<section class="col-span-12 grid grid-cols-12 gap-4 mt-16 lg:mt-28 border-b-stone-500 dark:border-b-stone-100 border-b-8" id="transactionSection">
		<div class="grid grid-cols-12 w-full col-span-12 my-16">
			<div class="col-span-12 lg:col-span-12" >
				<TransactionComponent />
			</div>
		</div>
	</section>
	<section class="col-span-12 grid grid-cols-12 gap-4 mt-16 lg:mt-28 " >
		<div class="grid grid-cols-12 w-full col-span-12 mb-16">
			<div class="col-span-1"></div>
			<div class="col-span-10 text-4xl mb-5 font-black md:text-5xl lg:text-4xl xl:text-5xl text-center">The Impact of Your Donation</div>
			<div class="col-span-1"></div>
			<div class="col-span-1 lg:col-span-4"></div>
			<div class="col-span-10 lg:col-span-4 md:text-lg text-center">Discover the tangible difference your donation makes in empowering students and schools for a brighter future.</div>
			<div class="col-span-1 lg:col-span-4"></div>
		</div>
		<div class="grid grid-cols-12 w-full col-span-12 place-items-center" id="impactSection">
			<div class="col-span-12 lg:col-span-6 px-5 md:px-20 lg:px-20 flex flex-col justify-center gap-y-16">
				<div class="flex">
					<div class="grid grid-cols-12">
						<div class="col-span-12 md:col-span-2">
							<div class="w-16 h-16 bg-stone-800 dark:bg-stone-100 rounded-md flex items-center justify-center ml-5 lg:ml-0">
								<svg width="40" height="40" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
									<path d="M36.6666 16.6668V26.6668M36.6666 16.6668L19.9999 8.3335L3.33325 16.6668L19.9999 25.0002L36.6666 16.6668Z" stroke="{svgMode}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
									<path d="M10 20V28.3333C15 33.3333 25 33.3333 30 28.3333V20" stroke="{svgMode}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
								</svg>
							</div>
						</div>
						<div class="col-span-12 mt-5 md:mt-0 md:col-span-10 ml-5">
							<p class="font-semibold text-2xl mb-5">Scholarships and Educational Resources</p>
							<p class="text-pretty">Empower students with scholarships and vital educational resources, ensuring they have the opportunity to thrive.</p>
						</div>
					</div>
				</div>
				<div class="flex">
					<div class="grid grid-cols-12">
						<div class="col-span-12 md:col-span-2" >
							<div class="w-16 h-16 bg-stone-800 dark:bg-stone-100 rounded-md flex items-center justify-center ml-5 lg:ml-0">
								<svg width="40" height="40" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
									<path d="M33.3333 26.6666V11.6666C33.3333 10.7825 32.9821 9.93468 32.357 9.30956C31.7319 8.68444 30.884 8.33325 30 8.33325H9.99995C9.1159 8.33325 8.26805 8.68444 7.64293 9.30956C7.01781 9.93468 6.66662 10.7825 6.66662 11.6666V26.6666M33.3333 26.6666H6.66662M33.3333 26.6666L35.4666 30.9166C35.5951 31.1716 35.6559 31.4553 35.6433 31.7405C35.6306 32.0258 35.5449 32.303 35.3943 32.5456C35.2438 32.7882 35.0334 32.988 34.7834 33.1259C34.5334 33.2639 34.2521 33.3352 33.9666 33.3333H6.03329C5.74777 33.3352 5.46653 33.2639 5.21653 33.1259C4.96653 32.988 4.75616 32.7882 4.60558 32.5456C4.45501 32.303 4.36928 32.0258 4.35662 31.7405C4.34396 31.4553 4.40479 31.1716 4.53329 30.9166L6.66662 26.6666" stroke="{svgMode}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
								</svg>
							</div>
						</div>
						<div class="col-span-12 mt-5 md:mt-0 md:col-span-10 ml-5">
							<p class="font-semibold text-2xl mb-5">Tech Integration</p>
							<p class="text-pretty">Equip classrooms with technology, empowering teachers and preparing students for success in the digital world.</p>
						</div>
					</div>
				</div>
				<div class="flex">
					<div class="grid grid-cols-12">
						<div class="col-span-12 md:col-span-2">
							<div class="w-16 h-16 bg-stone-800 dark:bg-stone-100 rounded-md flex items-center justify-center ml-5 lg:ml-0">
								<svg width="40" height="40" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
									<path d="M36.6666 20H3.33325" stroke="{svgMode}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
									<path d="M9.08325 8.51675L3.33325 20.0001V30.0001C3.33325 30.8841 3.68444 31.732 4.30956 32.3571C4.93468 32.9822 5.78253 33.3334 6.66659 33.3334H33.3333C34.2173 33.3334 35.0652 32.9822 35.6903 32.3571C36.3154 31.732 36.6666 30.8841 36.6666 30.0001V20.0001L30.9166 8.51675C30.6406 7.96139 30.2152 7.49403 29.6882 7.16721C29.1611 6.8404 28.5534 6.66708 27.9333 6.66675H12.0666C11.4464 6.66708 10.8387 6.8404 10.3117 7.16721C9.78463 7.49403 9.35921 7.96139 9.08325 8.51675Z" stroke="{svgMode}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
									<path d="M10 26.6667H10.0167" stroke="{svgMode}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
									<path d="M16.6667 26.6667H16.6834" stroke="{svgMode}" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
								</svg>									
							</div>
						</div>
						<div class="col-span-12 mt-5 md:mt-0 md:col-span-10 ml-5">
							<p class="font-semibold text-2xl mb-5">Infrastructure Development</p>
							<p class="text-pretty">Improve school facilities, providing safe and enriching environments for learning and growth.</p>
						</div>
					</div>
				</div>
			</div>			
			<div class="col-span-2 lg:hidden"></div>
			<div class="col-span-10 inset-0 bottom-0 lg:col-span-6 mt-9 lg:mt-0 rounded-tl-[8rem] bg-stone-900 dark:bg-white pt-12 pl-12">
				<div class="border-stone-300 dark:border-stone-800 dark:bg-stone-800 border-t-8 border-l-8 rounded-tl-[5rem]">
					<picture>
						<source media="(min-width: 768px)" srcset="{LPImageDesktop2}" />
						<img src="{LPImageMobile2}" alt="entity" class="w-full h-full object-cover rounded-tl-[4.5rem]"/>
					</picture>
				</div>
			</div>
		</div>
	</section>
</main>