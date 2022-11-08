N = 32

for mux in range(N):
    inputs_list = []
    for i in range(N):
        if i <= mux:
            inputs_list.append(f"in[{mux-i}]")
        else:
            inputs_list.append("0")
    inputs = ", ".join(inputs_list)
    print(f"mux32 mux{mux} ({inputs}, shamt, out[{mux}]);")
