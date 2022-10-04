`timescale 1ns / 1ps
`default_nettype none

`define SIMULATION

module test_decoders;
  logic ena;
  logic [1:0] in;
  wire [3:0] out;

  decoder_2_to_4 UUT(ena, in, out);

  initial begin // In standard programming land (line by line execution)
    // Collect waveforms
    $dumpfile("decoder_2_to_4.fst");
    $dumpvars(0, UUT);
    
    ena = 1;
    $display("ena in | out");
    for (int i = 0; i < 4; i = i + 1) begin
      in = i[1:0];
      #1 $display("%1b %2b | %4b", ena, in, out);
    end

    ena = 0;
    for (int i = 0; i < 4; i = i + 1) begin
      in = i[1:0];
      #1 $display("%1b %2b | %4b", ena, in, out);
    end
        
    $finish;      
	end

endmodule
