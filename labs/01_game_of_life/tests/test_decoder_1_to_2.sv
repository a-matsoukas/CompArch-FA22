`timescale 1ns / 1ps
`default_nettype none

`define SIMULATION

module test_decoders;
  // flip all logic/wires from the UUT (Unit Under Test)
  logic ena;
  logic in;
  wire [1:0] out;

  decoder_1_to_2 UUT(
    // .name_of_module_port(name_of_local_wire_or_logic)
    // to avoid confusion about which port is which
    .ena(ena), 
    .in(in), 
    .out(out)
);

  initial begin
    // Collect waveforms
    $dumpfile("decoder_1_to_2.fst");
    $dumpvars(0, UUT);
    
    ena = 1;
    $display("ena in | out");
    for (int i = 0; i < 2; i = i + 1) begin
      in = i[0];
      #1 $display("%1b %2b | %4b", ena, in, out);
    end

    ena = 0;
    for (int i = 0; i < 2; i = i + 1) begin
      in = i[0];
      #1 $display("%1b %2b | %4b", ena, in, out);
    end
        
    $finish;      
	end

endmodule
