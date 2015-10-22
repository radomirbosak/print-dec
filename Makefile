all:
	nasm -f elf64 -o print64dec.o print64dec.asm
	ld -o Print64dec print64dec.o

clear:
	rm print64dec.o Print64dec