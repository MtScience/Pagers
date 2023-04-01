from sys import argv, exit


def check_inputs(size: int, sigs: float | int) -> None:
    if size not in (12, 16, 20):
        exit("Incorrect input data: signature size must be either 12, 16 or 20")
    if not sigs.is_integer():
        exit("Incorrect input data: number of pages isn't divisible by signature size")


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


def print_signatures(sigs: list[tuple[list[str], list[str]]]) -> None:
    n = len(sigs)
    print(f"Total number of signatures is {n}.\n")

    for i, (s1, s2) in enumerate(sigs):
        print(f"Signature {i + 1}:")
        print(f"Side 1: {', '.join(s1)}")
        print(f"Side 2: {', '.join(s2)}\n")


if __name__ == "__main__":
    n_pages: int
    sig_size: int
    n_pages, sig_size = int(argv[1]), int(argv[2])

    n_sig: int | float = n_pages / sig_size

    check_inputs(sig_size, n_sig)
    n_sig = int(n_sig)
    signatures: list[tuple[list[str], list[str]]] = calculate_pages(n_pages, sig_size, n_sig)
    print_signatures(signatures)
