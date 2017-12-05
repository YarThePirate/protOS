My own implementation (with modifications) of the intermezzOS operating system

(https://intermezzos.github.io/book/)

... which is itself a modification to Writing an OS in Rust by Philipp Oppermann

(https://os.phil-opp.com/multiboot-kernel/)

## Notes

### Section 1: Background

- NASM = an assembly language build tool for linux, I think
- sooooo when I ran the two toy programs from this section, I had to echo the output from somewhere. This seemed super weird to me at the time, but now that I'm writing this it makes sense-ish. I mean, there were no I/O libraries being used, so the output *must* have been saved directly to a register or something. I'll have to look up what the "echo $?" command actually does.

### Section 2: Setting up a development environment

- "target triple" = architecture-kernel-userland
	- so in the webassembly target supported natively in rust, this targets genericWASM-unknownKernel-unknownUserland.
- triple can sometimes be extended to a quad (actually just called a "target" at that point), that includes the target OS
	- format would then be: architecture-os-kernel-userland
	- e.g. x86_64-debian-linux-gnu
- cross-compiling: when the target you are compiling to is different than the target of the host you're building on
	- e.g. building an arm OS from an x86_64-debian-linux-gnu system
	- ... or building to a generic kernel (x86_64-unknown-unknown) from a x86_64-debian-linux-gnu system
- looks like we'll be using QEMU to emulate the software we're building for. I was wondering about that.

### Section 3: Booting up

- Huh. In order to maintain backwards compatibility, x86 processors basically go through a rapid evolution from the original 8086 to now in succession on bootup. The boot process is just a bunch of more modern hacks tacked on to whatever came before.
- It gots through various "modes" that kind of simulate the architecture through time:
	1) 'real mode' : 16-bit mode from the original x86 chips
	2) 'protected mode' : 32-bit mode. called "protected" because this was the first time the hardware protected itself by restricting permissions
	3) 'long mode' : 64-bits (but it actually goes into 'compatibility mode' first... thanks, amd.)
- our goal: progress up the boot ladder and wind up in "long mode"

#### 1) Step 1: Firmware and BIOS
- BIOS is a tiny, read-only program that essentially runs a self-diagnostic and then looks for a boot image to load
- does this by looking for "magic numbers" set in the drive's memory... be prepared for more magicks >.<
- The boot code that the BIOS loads is NOT the kernel (yet); it's a bootloader
	- in our case, the bootloader we're using is GRUB.
	- the bootloader is responsible for loading the kernel into memory
	- GRUB will also handle the transition from real mode to protected mode *for us*
		- search for "A20 line" to find out what we would have needed to know otherwise
- GRUB, by convention, looks for the label 'start' and executes that
- I'll keep my notes on x86 instructions to a minimum, but so far:
	- mov -> mov size place thing (mov word [0xb8000], 0x0248 )
	- The screen is "memory mapped" to start at 0xb8000, meaning that whatever (e.g.) ASCII character is stored in memory location 0xb8000 will appear in the top left of the screen
		- this item takes up 2 bytes: foreground color (4 bits), text color (4 bits), ASCII character code in hex (8 bits)
		- e.g. 0x0257 = black background (0x0___) with green text (0x_2__) and ASCII 'W' (0x__57)
- ... And just like that, I finally understand what "linking" is.
	- we've compiled our two assembly files separately (multiboot_header.o and boot.o), but GRUB will only be looking for *one* binary file
	- linking glues both of these .o files together into a single item for the bootloader to load
	- .........
	- EUREKA!!! My baby kernel runs! 8D (I had to follow the 'code 0009' common error fix in Appendix A for it to work; other than that, all is well)