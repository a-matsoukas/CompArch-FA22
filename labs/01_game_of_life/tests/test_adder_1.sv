`timescale 1ns / 1ps
`default_nettype none

`define SIMULATION

module test_adder_1;
  logic a, b, c_in;
  wire out;

  adder_1 UUT(a, b, c_in, sum, c_out);

  initial begin // In standard programming land (line by line execution)
    // Collect waveforms
    $dumpfile("adder_1.fst");
    $dumpvars(0, UUT);
    
    a = 0;
    $display("in c_in | sum c_out");
    for (int i = 0; i < 4; i = i + 1) begin
      b = i[0];
      c_in = i[1];
      #1 $display("%1b %1b %1b | %1b %1b", a, b, c_in, sum, c_out);
    end

    a = 1;
    for (int i = 0; i < 4; i = i + 1) begin
      b = i[0];
      c_in = i[1];
      #1 $display("%1b %1b %1b | %1b %1b", a, b, c_in, sum, c_out);
    end
        
    $finish;      
	end

endmodule
