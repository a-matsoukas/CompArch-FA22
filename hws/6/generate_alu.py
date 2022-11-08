N = 16

for mux in range(N):
    print(f"mux16 select_type{mux:02d}(0, mux_in_and[{mux}], mux_in_or[{mux}],\
mux_in_xor[{mux}], 0, mux_in_sll[{mux}], mux_in_srl[{mux}],\
mux_in_sra[{mux}], mux_in_add[{mux}], 0, 0, 0, 0, mux_in_sub[{mux}],\
mux_in_slt[{mux}], mux_in_sltu[{mux}], control, result[{mux}]); \n")
