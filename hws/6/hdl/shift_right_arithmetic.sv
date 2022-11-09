`timescale 1ns/1ps
`default_nettype none
module shift_right_arithmetic(in,shamt,out);
parameter N = 32; // only used as a constant! Don't feel like you need to a shifter for arbitrary N.

//port definitions
input  wire [N-1:0] in;    // A 32 bit input
input  wire [$clog2(N)-1:0] shamt; // Shift ammount
output wire [N-1:0] out; // The same as SRL, but maintain the sign bit (MSB) after the shift! 
// It's similar to SRL, but instead of filling in the extra bits with zero, we
// fill them in with the sign bit.
// Remember the *repetition operator*: {n{bits}} will repeat bits n times.

mux32 #(.N(32)) SRA_MUX (
  .in00(in),
  .in01({ { (01) {in[N-1]}} , in[N-1:1]  }),
  .in02({ { (02) {in[N-1]}} , in[N-1:2]  }),
  .in03({ { (03) {in[N-1]}} , in[N-1:3]  }),
  .in04({ { (04) {in[N-1]}} , in[N-1:4]  }),
  .in05({ { (05) {in[N-1]}} , in[N-1:5]  }),
  .in06({ { (06) {in[N-1]}} , in[N-1:6]  }),
  .in07({ { (07) {in[N-1]}} , in[N-1:7]  }),
  .in08({ { (08) {in[N-1]}} , in[N-1:8]  }),
  .in09({ { (09) {in[N-1]}} , in[N-1:9]  }),
  .in10({ { (10) {in[N-1]}} , in[N-1:10]  }),
  .in11({ { (11) {in[N-1]}} , in[N-1:11]  }),
  .in12({ { (12) {in[N-1]}} , in[N-1:12]  }),
  .in13({ { (13) {in[N-1]}} , in[N-1:13]  }),
  .in14({ { (14) {in[N-1]}} , in[N-1:14]  }),
  .in15({ { (15) {in[N-1]}} , in[N-1:15]  }),
  .in16({ { (16) {in[N-1]}} , in[N-1:16]  }),
  .in17({ { (17) {in[N-1]}} , in[N-1:17]  }),
  .in18({ { (18) {in[N-1]}} , in[N-1:18]  }),
  .in19({ { (19) {in[N-1]}} , in[N-1:19]  }),
  .in20({ { (20) {in[N-1]}} , in[N-1:20]  }),
  .in21({ { (21) {in[N-1]}} , in[N-1:21]  }),
  .in22({ { (22) {in[N-1]}} , in[N-1:22]  }),
  .in23({ { (23) {in[N-1]}} , in[N-1:23]  }),
  .in24({ { (24) {in[N-1]}} , in[N-1:24]  }),
  .in25({ { (25) {in[N-1]}} , in[N-1:25]  }),
  .in26({ { (26) {in[N-1]}} , in[N-1:26]  }),
  .in27({ { (27) {in[N-1]}} , in[N-1:27]  }),
  .in28({ { (28) {in[N-1]}} , in[N-1:28]  }),
  .in29({ { (29) {in[N-1]}} , in[N-1:29]  }),
  .in30({ { (30) {in[N-1]}} , in[N-1:30]  }),
  .in31({ { (31) {in[N-1]}} , in[N-1:31]  }),
  .select(shamt),
  .out(out)
);

// mux32 #(.N(N)) bit32_32mux(
//     .in00(in),
//     .in01({{1{in[N-1]}}, in[N-2:1]}),
//     .in02({{2{in[N-1]}}, in[N-2:2]}),
//     .in03({{3{in[N-1]}}, in[N-2:3]}),
//     .in04({{4{in[N-1]}}, in[N-2:4]}),
//     .in05({{5{in[N-1]}}, in[N-2:5]}),
//     .in06({{6{in[N-1]}}, in[N-2:6]}),
//     .in07({{7{in[N-1]}}, in[N-2:7]}),
//     .in08({{8{in[N-1]}}, in[N-2:8]}),
//     .in09({{9{in[N-1]}}, in[N-2:9]}),
//     .in10({{10{in[N-1]}}, in[N-1:10]}),
//     .in11({{11{in[N-1]}}, in[N-1:11]}),
//     .in12({{12{in[N-1]}}, in[N-1:12]}),
//     .in13({{13{in[N-1]}}, in[N-1:13]}),
//     .in14({{14{in[N-1]}}, in[N-1:14]}),
//     .in15({{15{in[N-1]}}, in[N-1:15]}),
//     .in16({{16{in[N-1]}}, in[N-1:16]}),
//     .in17({{17{in[N-1]}}, in[N-1:17]}),
//     .in18({{18{in[N-1]}}, in[N-1:18]}),
//     .in19({{19{in[N-1]}}, in[N-1:19]}),
//     .in20({{20{in[N-1]}}, in[N-1:20]}),
//     .in21({{21{in[N-1]}}, in[N-1:21]}),
//     .in22({{22{in[N-1]}}, in[N-1:22]}),
//     .in23({{23{in[N-1]}}, in[N-1:23]}),
//     .in24({{24{in[N-1]}}, in[N-1:24]}),
//     .in25({{25{in[N-1]}}, in[N-1:25]}),
//     .in26({{26{in[N-1]}}, in[N-1:26]}),
//     .in27({{27{in[N-1]}}, in[N-1:27]}),
//     .in28({{28{in[N-1]}}, in[N-1:28]}),
//     .in29({{29{in[N-1]}}, in[N-1:29]}),
//     .in30({{30{in[N-1]}}, in[N-1:30]}),
//     .in31({{31{in[N-1]}}, in[N-1:31]}),
//     .select(shamt),
//     .out(out));

endmodule
