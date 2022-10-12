`timescale 1ns / 1ps
`default_nettype none

`define SIMULATION

module test_decoders;
  parameter N_test = 5;

  logic [(N_test-1):0] in00, in01, in02, in03, in04, in05, in06, in07, in08, 
    in09, in10, in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, 
    in21, in22, in23, in24, in25, in26, in27, in28, in29, in30, in31;
  logic [4:0] select;
  wire [(N_test-1):0] out;

  mux32 UUT(in00, in01, in02, in03, in04, in05, in06, in07, in08, in09, in10, 
  in11, in12, in13, in14, in15, in16, in17, in18, in19, in20, in21, 
  in22, in23, in24, in25, in26, in27, in28, in29, in30, in31, select, out);
  
  initial begin // In standard programming land (line by line execution)
    // Collect waveforms
    $dumpfile("mux32.fst");
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
    in16 = 16; 
    in17 = 17; 
    in18 = 18; 
    in19 = 19; 
    in20 = 20; 
    in21 = 21; 
    in22 = 22; 
    in23 = 23; 
    in24 = 24; 
    in25 = 25; 
    in26 = 26; 
    in27 = 27; 
    in28 = 28; 
    in29 = 29; 
    in30 = 30; 
    in31 = 31;
    for (int i = 0; i < 32; i = i + 1) begin
      select = i[4:0];
      #1 $display("%4b | %d", select, out);
    end
        
    $finish;      
	end

endmodule
