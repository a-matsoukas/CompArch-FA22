N = 16
M = 32

for idx in range(M):
    print(f"mux16 select_type{idx:02d}(0, idx_in_and[{idx}], idx_in_or[{idx}],\
idx_in_xor[{idx}], 0, idx_in_sll[{idx}], idx_in_srl[{idx}],\
idx_in_sra[{idx}], idx_in_add[{idx}], 0, 0, 0, 0, idx_in_sub[{idx}],\
idx_in_slt[{idx}], idx_in_sltu[{idx}], control, result[{idx}]);")
