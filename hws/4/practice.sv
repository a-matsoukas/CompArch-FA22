`timescale 1ns/1ps
`default_nettype none

module practice(rst, clk, ena, seed, out);

input wire rst, clk, ena, seed;
output logic out;

logic ff0_Q, ff1_Q, xor_out, mux_out, ena_bar;

always_comb begin
    ena_bar = ~ena;
    xor_out = ff0_Q ^ ff1_Q;
    mux_out = (ena & xor_out) | (ena_bar & seed);
end

always_ff @( posedge clk ) begin
    out <= ff1_Q;
    ff1_Q <= ff0_Q;
    ff0_Q <= mux_out;
end

endmodule
