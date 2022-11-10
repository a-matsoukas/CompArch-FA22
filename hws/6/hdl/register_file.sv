`default_nettype none
`timescale 1ns/1ps

module register_file(
  clk, //Note - intentionally does not have a reset! 
  wr_ena, wr_addr, wr_data,
  rd_addr0, rd_data0,
  rd_addr1, rd_data1
);
// Not parametrizing, these widths are defined by the RISC-V Spec!
input wire clk;

// Write channel
input wire wr_ena;
input wire [4:0] wr_addr;
input wire [31:0] wr_data;

// Two read channels
input wire [4:0] rd_addr0, rd_addr1;
output logic [31:0] rd_data0, rd_data1;

logic [31:0] x00; 
always_comb x00 = 32'd0; // ties x00 to ground. 
logic [31:0] ena_bus;

// DON'T DO THIS:
// logic [31:0] register_file_registers [31:0]
// CAN'T: because that's a RAM. Works in simulation, fails miserably in synthesis.

// Hint - use a scripting language if you get tired of copying and pasting the logic 32 times - e.g. python: print(",".join(["x%02d"%i for i in range(0,32)]))
wire [31:0] x01,x02,x03,x04,x05,x06,x07,x08,x09,x10,x11,x12,x13,x14,x15,x16,x17,x18,x19,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31;
logic [31:0] d, q;

register #(.N(32)) REG_01 (
  .clk(clk), .ena(ena_bus[1]), .rst(1'b0), .d(wr_data), .q(x01)
);

register #(.N(32)) REG_02 (
  .clk(clk), .ena(ena_bus[2]), .rst(1'b0), .d(wr_data), .q(x02)
);

register #(.N(32)) REG_03 (
  .clk(clk), .ena(ena_bus[3]), .rst(1'b0), .d(wr_data), .q(x03)
);

register #(.N(32)) REG_04 (
  .clk(clk), .ena(ena_bus[4]), .rst(1'b0), .d(wr_data), .q(x04)
);

register #(.N(32)) REG_05 (
  .clk(clk), .ena(ena_bus[5]), .rst(1'b0), .d(wr_data), .q(x05)
);

register #(.N(32)) REG_06 (
  .clk(clk), .ena(ena_bus[6]), .rst(1'b0), .d(wr_data), .q(x06)
);

register #(.N(32)) REG_07 (
  .clk(clk), .ena(ena_bus[7]), .rst(1'b0), .d(wr_data), .q(x07)
);

register #(.N(32)) REG_08 (
  .clk(clk), .ena(ena_bus[8]), .rst(1'b0), .d(wr_data), .q(x08)
);

register #(.N(32)) REG_09 (
  .clk(clk), .ena(ena_bus[9]), .rst(1'b0), .d(wr_data), .q(x09)
);

register #(.N(32)) REG_10 (
  .clk(clk), .ena(ena_bus[10]), .rst(1'b0), .d(wr_data), .q(x10)
);

register #(.N(32)) REG_11 (
  .clk(clk), .ena(ena_bus[11]), .rst(1'b0), .d(wr_data), .q(x11)
);

register #(.N(32)) REG_12 (
  .clk(clk), .ena(ena_bus[12]), .rst(1'b0), .d(wr_data), .q(x12)
);

register #(.N(32)) REG_13 (
  .clk(clk), .ena(ena_bus[13]), .rst(1'b0), .d(wr_data), .q(x13)
);

register #(.N(32)) REG_14 (
  .clk(clk), .ena(ena_bus[14]), .rst(1'b0), .d(wr_data), .q(x14)
);

register #(.N(32)) REG_15 (
  .clk(clk), .ena(ena_bus[15]), .rst(1'b0), .d(wr_data), .q(x15)
);

register #(.N(32)) REG_16 (
  .clk(clk), .ena(ena_bus[16]), .rst(1'b0), .d(wr_data), .q(x16)
);

register #(.N(32)) REG_17 (
  .clk(clk), .ena(ena_bus[17]), .rst(1'b0), .d(wr_data), .q(x17)
);

register #(.N(32)) REG_18 (
  .clk(clk), .ena(ena_bus[18]), .rst(1'b0), .d(wr_data), .q(x18)
);

register #(.N(32)) REG_19 (
  .clk(clk), .ena(ena_bus[19]), .rst(1'b0), .d(wr_data), .q(x19)
);

register #(.N(32)) REG_20 (
  .clk(clk), .ena(ena_bus[20]), .rst(1'b0), .d(wr_data), .q(x20)
);

register #(.N(32)) REG_21 (
  .clk(clk), .ena(ena_bus[21]), .rst(1'b0), .d(wr_data), .q(x21)
);

register #(.N(32)) REG_22 (
  .clk(clk), .ena(ena_bus[22]), .rst(1'b0), .d(wr_data), .q(x22)
);

register #(.N(32)) REG_23 (
  .clk(clk), .ena(ena_bus[23]), .rst(1'b0), .d(wr_data), .q(x23)
);

register #(.N(32)) REG_24 (
  .clk(clk), .ena(ena_bus[24]), .rst(1'b0), .d(wr_data), .q(x24)
);

register #(.N(32)) REG_25 (
  .clk(clk), .ena(ena_bus[25]), .rst(1'b0), .d(wr_data), .q(x25)
);

register #(.N(32)) REG_26 (
  .clk(clk), .ena(ena_bus[26]), .rst(1'b0), .d(wr_data), .q(x26)
);

register #(.N(32)) REG_27 (
  .clk(clk), .ena(ena_bus[27]), .rst(1'b0), .d(wr_data), .q(x27)
);

register #(.N(32)) REG_28 (
  .clk(clk), .ena(ena_bus[28]), .rst(1'b0), .d(wr_data), .q(x28)
);

register #(.N(32)) REG_29 (
  .clk(clk), .ena(ena_bus[29]), .rst(1'b0), .d(wr_data), .q(x29)
);

register #(.N(32)) REG_30 (
  .clk(clk), .ena(ena_bus[30]), .rst(1'b0), .d(wr_data), .q(x30)
);

register #(.N(32)) REG_31 (
  .clk(clk), .ena(ena_bus[31]), .rst(1'b0), .d(wr_data), .q(x31)
);

mux32 #(.N(32)) MUX00 (
  .in00(x00), .in01(x01), .in02(x02), .in03(x03), 
  .in04(x04), .in05(x05), .in06(x06), .in07(x07), 
  .in08(x08), .in09(x09), .in10(x10), .in11(x11), 
  .in12(x12), .in13(x13), .in14(x14), .in15(x15), 
  .in16(x16), .in17(x17), .in18(x18), .in19(x19), 
  .in20(x20), .in21(x21), .in22(x22), .in23(x23), 
  .in24(x24), .in25(x25), .in26(x26), .in27(x27), 
  .in28(x28), .in29(x29), .in30(x30), .in31(x31), 
  .select(rd_addr0), .out(rd_data0)
);

mux32 #(.N(32)) MUX01 (
  .in00(x00), .in01(x01), .in02(x02), .in03(x03), 
  .in04(x04), .in05(x05), .in06(x06), .in07(x07), 
  .in08(x08), .in09(x09), .in10(x10), .in11(x11), 
  .in12(x12), .in13(x13), .in14(x14), .in15(x15), 
  .in16(x16), .in17(x17), .in18(x18), .in19(x19), 
  .in20(x20), .in21(x21), .in22(x22), .in23(x23), 
  .in24(x24), .in25(x25), .in26(x26), .in27(x27), 
  .in28(x28), .in29(x29), .in30(x30), .in31(x31), 
  .select(rd_addr1), .out(rd_data1)
);

decoder_5_to_32 decoder_writing(wr_ena, wr_addr, ena_bus);

endmodule