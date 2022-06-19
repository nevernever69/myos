asm= nasm
1 = sector1
2 = sector2
bo = bootloader.asm
ex = extended.asm
dbo = bootloader.bin
dex = extended.bin
gcc = i686-elf-gcc
flags = -Ttext 0x8000 -nostdlib  -ffreestanding -mno-red-zone -m64 -c

oex = extended.o
3 = kernel1
all: final.img sector

final.img: final.bin
	cp final.bin final.img 


final.bin: binary
	cat $(dbo) kernel.bin  > final.bin
binary:  sector kernel 

kernel: kernel.o
	ld -T"link.ld"

kernel.o: $(3)/kernel.c
	gcc $(flags) $(3)/kernel.c -o kernel.o

sector: sector1 sector2  

sector1: bootloader.bin
bootloader.bin: $(1)/$(bo)
	nasm -f bin $(1)/$(bo) -o $(dbo)

sector2: $(oex)

$(oex): $(2)/$(ex)
	nasm -f elf64 $(2)/$(ex) -o $(oex)

clean: 
	rm *.bin *.o
	
run: 
	qemu-system-x86_64 -fda final.bin

bochs:
	bochs -f boch-config
