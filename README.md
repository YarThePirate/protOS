My own implementation (with modifications) of the intermezzOS operating system

(https://intermezzos.github.io/book/)

... which is itself a modification to Writing an OS in Rust by Philipp Oppermann

(https://os.phil-opp.com/multiboot-kernel/)

##Notes

###Section 1: Background

- NASM = an assembly language build tool for linux, I think
- sooooo when I ran the two toy programs from this section, I had to echo the output from somewhere. This seemed super weird to me at the time, but now that I'm writing this it makes sense-ish. I mean, there were no I/O libraries being used, so the output *must* have been saved directly to a register or something. I'll have to look up what the "echo $?" command actually does.

###Section 2: Setting up a development environment

- "target triple" = architecture-kernel-userland
	- so in the webassembly target supported natively in rust, this targets genericWASM-unknownKernel-unknownUserland.
- triple can sometimes be extended to a quad, that includes the target OS
	- format would then be: architecture-os-kernel-userland
	- e.g. x86_64-debian-linux-gnu