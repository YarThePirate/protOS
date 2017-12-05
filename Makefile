multiboot_header.o: multiboot_header.asm
	nasm -f elf64 multiboot_header.asm