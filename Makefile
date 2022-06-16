asm= nasm
1 = sector1
2 = sector2
bo = bootloader.asm
ex = extended.asm
dbo = bootloader.bin
dex = extended.bin
gcc = i686-elf-gcc
flags = "--ffreestanding -mno-red-zone -m64 -c"
3 = kernel
all: final.img sector

final.img: final.bin
	cp final.bin final.img 


final.bin: sector
	cat $(dbo) $(dex) > final.bin

sector: sector1 sector2 

sector1: bootloader.bin

bootloader.bin: $(1)/$(bo)
	nasm -f bin $(1)/$(bo) -o $(dbo)

sector2: $(dex)

$(dex): $(2)/$(ex)
	nasm -f bin $(2)/$(ex) -o $(dex)



clean: 
	rm *.bin
	
run: 
	qemu-system-i386 final.bin

bochs:
	bochs -f boch-config
