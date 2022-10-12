	
`timescale 1ns/1ps
`default_nettype none
/*
  Making 32 different inputs is annoying, so I use python:
  print(", ".join([f"in{i:02}" for i in range(32)]))
  The solutions will include comments for where I use python-generated HDL.
*/

module mux4(
  in0, in1, in2, in3, select, out
);
	//parameter definitions
	parameter N = 5;
	//port definitions
  // python: print(", ".join([f"in{i:02}" for i in range(32)]))
	input  wire [(N-1):0] in0, in1, in2, in3;
	input  wire [1:0] select;
	output logic [(N-1):0] out;

  logic [(N-1):0] mux_out0, mux_out1;

  assign mux_out0 = select[0] ? in1 : in0;
  assign mux_out1 = select[0] ? in3 : in2;
  assign out = select[1] ? mux_out1 : mux_out0;

endmodule
