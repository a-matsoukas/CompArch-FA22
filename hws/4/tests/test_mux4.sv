`timescale 1ns / 1ps
`default_nettype none

`define SIMULATION

module test_decoders;
  parameter N_test = 5;

  logic [(N_test-1):0] in00, in01, in02, in03;
  logic [1:0] select;
  wire [(N_test-1):0] out;

  mux4 UUT(in00, in01, in02, in03, select, out);
  
  initial begin // In standard programming land (line by line execution)
    // Collect waveforms
    $dumpfile("mux16.fst");
    $dumpvars(0, UUT);
    
    $display("select | out");
    in00 = 0; 
    in01 = 1; 
    in02 = 2; 
    in03 = 3; 
    for (int i = 0; i < 4; i = i + 1) begin
      select = i[4:0];
      #1 $display("%5b | %d", select, out);
    end
        
    $finish;      
	end

endmodule
