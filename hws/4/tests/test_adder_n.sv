`timescale 1ns / 1ps
`default_nettype none

`define SIMULATION

module test_adder_n;
  parameter N = 32;
  logic [31:0] a, b;
  logic c_in;
  wire [31:0] sum, c_out;

  adder_n  #(.N(32)) UUT(a, b, c_in, sum, c_out);

  initial begin // In standard programming land (line by line execution)
    // Collect waveforms
    $dumpfile("adder_n.fst");
    $dumpvars(0, UUT);
    
    c_in = 0;
    a = 0;
    $display("a b | sum | computed diff");
    for (int j = 0; j < 12; j = j + 1) begin
      for (int i = 2147483640; i < 2147483647; i = i + 1) begin
        a = j;
        b = i;
        #1 $display("%d %d | %d %d", a, b, sum, (a+b), (a+b-sum));
      end
    end       
    $finish;      
	end

endmodule
