import sys
import struct

# This script generates a RPI Pico 2 UF2 from a bin.

# The UF2 block structure is as follows (little endian, except for data):
#	struct UF2_Block {
#		// 32 byte header
#		uint32_t magicStart0;
#		uint32_t magicStart1;
#		uint32_t flags;
#		uint32_t targetAddr;
#		uint32_t payloadSize;
#		uint32_t blockNo;
#		uint32_t numBlocks;
#		uint32_t fileSize; // or familyID;
#		uint8_t data[476];
#		uint32_t magicEnd;
#	} UF2_Block;
#

UF2_MAGIC1 = 0x0A324655
UF2_MAGIC2 = 0x9E5D5157
UF2_MAGIC_END = 0x0AB16F30

UF2_FLAG_FAMILY_ID_PRESENT = 0x00002000
RP2_FAMILY_ID_SECURE_ARM = 0xe48bff59
RP2_FAMILY_ID_RISCV = 0xe48bff5a
RP2_FAMILY_ID_NONSECURE_ARM = 0xe48bff5b

BLOCK_SIZE = 512
PAYLOAD_SIZE = 256

def generate_block(address, block_no, total_blocks, chunk):
	payload = chunk + bytes(256 - len(chunk))
	header = struct.pack("<IIIIIIII",
		UF2_MAGIC1,
		UF2_MAGIC2,
		UF2_FLAG_FAMILY_ID_PRESENT,
		address,
		PAYLOAD_SIZE,
		block_no,
		total_blocks,
		RP2_FAMILY_ID_SECURE_ARM,
	)
	footer = struct.pack("<I",
		UF2_MAGIC_END
	)
	padding = bytes(BLOCK_SIZE - len(chunk) - len(header) - len(footer))
	return header + chunk + padding + footer


def main():
	if len(sys.argv) != 4:
		print("Usage: input.bin output.uf2 <base_addr>")
		sys.exit(1)

	in_path  = sys.argv[1]
	out_path = sys.argv[2]
	base_addr = int(sys.argv[3], 0)

	with open(in_path, "rb") as f:
		data = f.read()

	chunks = [data[i:i+PAYLOAD_SIZE] for i in range(0, len(data), PAYLOAD_SIZE)]
	total_blocks = len(chunks)
	out = bytearray()
	addr = base_addr
	for i, ch in enumerate(chunks):
		out += generate_block(addr, i, total_blocks, ch)
		addr += BLOCK_SIZE

	with open(out_path, "wb") as f:
		f.write(out)

if __name__ == "__main__":
	main()