

part1.bin: part1.o
	ld65 -C ../../micro.cfg part1.o -o part1.bin

part1.o: part1.asm ../../devices.s
	ca65 part1.asm

part2.bin: part2.o
	ld65 -C ../../micro.cfg part2.o -o part2.bin

part2.o: part2.asm ../../devices.s
	ca65 part2.asm

.PHONY: clean
clean:
	rm -rf *.o startme.bin

.PHONY: flash
flash: startme.bin
	minipro -p AT28HC256 -s -w startme.bin

