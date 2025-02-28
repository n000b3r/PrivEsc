import base64
import sys

if len(sys.argv) != 2:
    print("Usage: python encode_ps.py <filename>")
    sys.exit(1)

with open(sys.argv[1], "r", encoding="utf-8") as file:
    data = file.read().strip()

encoded_command = base64.b64encode(data.encode("utf-16le")).decode()
print(encoded_command)

