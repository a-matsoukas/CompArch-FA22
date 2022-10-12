# Homework 4
The written portion is available [here](https://docs.google.com/document/d/1XybXmTD5-NTJ1gfLq3tYb-wUUDJGZS8xgO912DLf50Q/edit?usp=sharing)

Add a pdf of your written answers to this folder, then use `make clean` then `make submission` to submit!

## Schematics 
Please see the end of the homework_4.pdf for schematics of implementing mux32 and adder_n (32).

## Testing mux32
I tested mux32 by assigning values `0` to `31` to `in00` to `in31` respectively. Then, I found `out` for all addresses (`00000` to `11111`) and compared the address to the value of `out`. For instance, for address `00100` which should link to `in04`, we would expect the `out` to equal `in04`, which equals `4`. To run it, run `make test_mux32`.

```
select | out
00000 |  0
00001 |  1
00010 |  2
00011 |  3
00100 |  4
00101 |  5
00110 |  6
00111 |  7
01000 |  8
01001 |  9
01010 | 10
01011 | 11
01100 | 12
01101 | 13
01110 | 14
01111 | 15
10000 | 16
10001 | 17
10010 | 18
10011 | 19
10100 | 20
10101 | 21
10110 | 22
10111 | 23
11000 | 24
11001 | 25
11010 | 26
11011 | 27
11100 | 28
11101 | 29
11110 | 30
11111 | 31
```