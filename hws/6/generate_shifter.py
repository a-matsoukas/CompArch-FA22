N = 32

# SLL
# for mux in range(N):
#     inputs_list = []
#     for i in range(N):
#         if i <= mux:
#             inputs_list.append(f"in[{mux-i}]")
#         else:
#             inputs_list.append("1'b0")
#     inputs = ", ".join(inputs_list)
#     print(f"mux32 mux{mux} ({inputs}, shamt, out[{mux}]);")

# SRL
# for mux in range(N):
#     inputs_list = []
#     for i in range(N):
#         if (mux + i < N):
#             inputs_list.append(f"in[{mux + i}]")
#         else:
#             inputs_list.append("1'b0")
#     inputs = ", ".join(inputs_list)
#     print(f"mux32 mux{mux} ({inputs}, shamt, out[{mux}]);")

# SRA
for input in range(1,N):
    print(f".in{input:02d}({{{{{input}{{in[N-1]}}}}, in[N-1:{input}]}}),")