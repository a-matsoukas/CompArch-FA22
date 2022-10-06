`default_nettype none
`timescale 1ns/1ps

module conway_cell(clk, rst, ena, state_0, state_d, state_q, neighbors);
input wire clk;
input wire rst;
input wire ena;

input wire state_0;
output logic state_d; // NOTE - this is only an output of the module for debugging purposes. 
output logic state_q;

input wire [7:0] neighbors;

// Sum thing?
logic [3:0] sum;
assign sum = 4'b0;
logic c_out;
assign c_out = 1'b0;
// logic [3:0] tmp;

generate
    genvar i, tmp;
    for(i = 0; i < 4; i++) begin
        // tmp = 4'b1 & neighbors[i];
        // assign tmp = 4'b1; // neighbors[i] == 1 ? 4'b1 : 4'b0;
        adder_n #(.N(4)) adder_4bit (
            .a(sum),
            .b(4'b1),
            .c_in(1'b0),
            .sum(sum),
            .c_out(c_out));
    end
endgenerate

always_ff @( posedge clk ) begin
    state_q <= ena & ~rst & ((sum == 3) | (state_0 & (sum == 2)));
end





endmodule