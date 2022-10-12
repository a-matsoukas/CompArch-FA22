	
`timescale 1ns/1ps
`default_nettype none

module mux16(
  mux16_in00, mux16_in01, mux16_in02, mux16_in03, mux16_in04, mux16_in05, mux16_in06, mux16_in07, mux16_in08, mux16_in09, mux16_in10, 
  mux16_in11, mux16_in12, mux16_in13, mux16_in14, mux16_in15, select, out
);
	//parameter definitions
	parameter mux16_N = 5;
	//port definitions
  // python: print(", ".join([f"in{i:02}" for i in range(32)]))
	input  wire [(mux16_N-1):0] mux16_in00, mux16_in01, mux16_in02, mux16_in03, mux16_in04, mux16_in05, mux16_in06, mux16_in07, mux16_in08, mux16_in09, mux16_in10, 
  mux16_in11, mux16_in12, mux16_in13, mux16_in14, mux16_in15;
	input  wire [3:0] select;
	output logic [(mux16_N-1):0] out;

  logic [(mux16_N-1):0] mux16_out0, mux16_out1, mux16_out2, mux16_out3;

  // First stage of mux4's
  mux4 mux4_0(mux16_in00, mux16_in01, mux16_in02, mux16_in03, select[1:0], mux16_out0);
  mux4 mux4_1(mux16_in04, mux16_in05, mux16_in06, mux16_in07, select[1:0], mux16_out1);
  mux4 mux4_2(mux16_in08, mux16_in09, mux16_in10, mux16_in11, select[1:0], mux16_out2);
  mux4 mux4_3(mux16_in12, mux16_in13, mux16_in14, mux16_in15, select[1:0], mux16_out3);

  mux4 final_mux4(mux16_out0, mux16_out1, mux16_out2, mux16_out3, select[3:2], out);

endmodule
