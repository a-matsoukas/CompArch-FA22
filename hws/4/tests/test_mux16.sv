`timescale 1ns / 1ps
`default_nettype none

`define SIMULATION

module test_decoders;
  parameter N_test = 5;

  logic [(N_test-1):0] in00, in01, in02, in03, in04, in05, in06, in07, in08, 
    in09, in10, in11, in12, in13, in14, in15;
  logic [3:0] select;
  wire [(N_test-1):0] out;

  mux16 UUT(in00, in01, in02, in03, in04, in05, in06, in07, in08, in09, in10, 
  in11, in12, in13, in14, in15, select, out);
  
  initial begin // In standard programming land (line by line execution)
    // Collect waveforms
    $dumpfile("mux16.fst");
    $dumpvars(0, UUT);
    
    $display("select | out");
    in00 = 0; 
    in01 = 1; 
    in02 = 2; 
    in03 = 3; 
    in04 = 4; 
    in05 = 5; 
    in06 = 6; 
    in07 = 7; 
    in08 = 8; 
    in09 = 9; 
    in10 = 10; 
    in11 = 11; 
    in12 = 12; 
    in13 = 13; 
    in14 = 14; 
    in15 = 15; 
    for (int i = 0; i < 16; i = i + 1) begin
      select = i[4:0];
      #1 $display("%5b | %d", select, out);
    end
        
    $finish;      
	end

endmodule
