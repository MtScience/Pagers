# The Python 3 version of the pager program. It basically mirrors the Lua version.

from sys import argv, exit


# The function asking the user for input data, if it is not supplied via CLI arguments
def ask() -> tuple[int, int]:
    pages: int = int(input("Please, enter the number of pages in the book: "))
    sig_size: int = int(input("Please, enter the desired number of pages in a signature: "))

    return pages, sig_size


# Check inputs for correctness
def check_inputs(size: int, sigs: float | int) -> None:
    if size not in (12, 16, 20):
        exit("Incorrect input data: signature size must be either 12, 16 or 20")
    if not sigs.is_integer():
        exit("Incorrect input data: number of pages isn't divisible by signature size")


# Do the job: calculate, where each page should go
def calculate_pages(pages: int, size: int, sigs: int) -> list[tuple[list[str], list[str]]]:
    s: int = size // 2
    signatures: list[tuple[list[str], list[str]]] = []

    for i in range(sigs):
        s1: list[str] = []
        s2: list[str] = []

        for j in range(s):
            s1.append(str((size * i + s - (-1) ** j * (j - s) - 2) % pages))
            s2.append(str(1 + (size * i + s - (-1) ** j * j - 3) % pages))

        signatures.append((s1, s2))

    return signatures


# Output, obviously
def print_signatures(sigs: list[tuple[list[str], list[str]]]) -> None:
    n = len(sigs)
    print(f"Total number of signatures is {n}.\n")

    for i, (s1, s2) in enumerate(sigs):
        print(f"Signature {i + 1}:")
        print(f"Side 1: {', '.join(s1)}")
        print(f"Side 2: {', '.join(s2)}\n")


# The main block of the program
if __name__ == "__main__":
    n_pages: int
    sig_size: int

    if len(argv) >= 3:
        n_pages, sig_size = int(argv[1]), int(argv[2])
    else:
        n_pages, sig_size = ask()

    n_sig: int | float = n_pages / sig_size

    check_inputs(sig_size, n_sig)
    n_sig = int(n_sig)
    signatures: list[tuple[list[str], list[str]]] = calculate_pages(n_pages, sig_size, n_sig)
    print_signatures(signatures)
