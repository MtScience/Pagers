# Pagers

A little project that contains two simple programs for rearranging page numbers of typeset books for printing—making books is a hobby of mine. Originally written in Lua, later translated to Haskell and Python 3 as exercises.

## The principle

The programs work as follows.

When printing a book (four pages per a sheet of paper—two per side) you have to pair up pages in a very specific manner depending on the size of a signature (I use 12, 16 or 20 page signatures). After printing one side of the signature, you would have to rearrange the sheets, print the other side and rearrange again, which is a chore and takes time. Or at least, it works this way with my printer. So I decided to write a script, which would calculate page numbers for each signature in such a way, that would not require shuffling paper around. A little bit of mathematical magic and I got this formula:

```math
p_{ij} = \begin{cases}
  \left( S (i - 1) + s + (-1)^j (j - s - 1) - 2 \right) \mod N & \text{for side 1}\\[1pt]
  1 + \left( S (i - 1) + s + (-1)^j (j - 1) - 3 \right) \mod N & \text{for side 2}
\end{cases}
```

where:
* $p_{ij}$ is the page number at position $j$ in signature $i$ ($i, j \in \mathbb N$);
* $S$ is the signature size ($s \in \lbrace 12, 16, 20 \rbrace$);
* $s = \frac{S}{2}$;
* $N$ is the number of pages in the book.

This way you get a list of pairs of lists of page numbers (`[([Word32], [Word32])]` in Haskell type system), wehre each pair represents a signature. The first element is the list of pages for the first side and the second—for the second side. You can just copy-paste the output to the program you use to print without having to reshuffle sheets of paper.
