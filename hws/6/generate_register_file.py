def generate_rd_muxes_register():
    print("\n\n".join([f"mux32 #(.N(32)) MUX{i:02d} (\n{generate_connections_mux(i)}\n);" for i in range(2)]))

def generate_wr_registers():
    print("\n\n".join([f"register #(.N(32)) REG_{i:02d} (\n{generate_connections(i)}\n);" for i in range(32)]))

def generate_connections(index):
    contents = f"  .clk(clk), .ena(ena_bus[{index}]), .rst(1'b0), .d(wr_data), .q(x{index:02d})"
    return contents

def generate_connections_mux(index):
    contents = "  "

    for i in range(32):
        contents += f".in{i:02d}(x{i:02d}), "

        if (i + 1) % 4 == 0:
            contents += "\n  "

    contents += f".select(rd_addr{index}), .out(rd_data{index})"
    return contents

if __name__ == "__main__":
    generate_wr_registers()
    generate_rd_muxes_register()
   