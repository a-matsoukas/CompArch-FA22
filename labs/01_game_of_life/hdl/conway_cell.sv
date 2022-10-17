`default_nettype none
`timescale 1ns/1ps

module conway_cell(clk, rst, ena, state_0, state_d, state_q, neighbors);
input wire clk;
input wire rst;
input wire ena;

input wire state_0;
output logic [3:0] state_d; // NOTE - this is only an output of the module for debugging purposes. 
output logic state_q;

input wire [7:0] neighbors;

// Sum thing?
logic [3:0] sum;
logic c_out;

wire [35:0] sum_memory;
assign sum_memory[3:0] = 4'b0;
assign sum = sum_memory[35:32];

wire [7:0] carries_out;

generate
    genvar i;
    for(i = 0; i < 8; i++) begin
        // tmp = 4'b1 & neighbors[i];
        // assign tmp = 4'b1; // neighbors[i] == 1 ? 4'b1 : 4'b0;
        adder_n #(.N(4)) adder_4bit (
            .a(sum_memory[i*4 + 3 : i*4]),
            .b(neighbors[i]),
            .c_in(1'b0),
            .sum(sum_memory[(i + 1)*4 + 3 : (i + 1)*4]),
            .c_out(carries_out[i]));
    end
endgenerate

always_ff @( posedge clk ) begin
    state_q <= ena & ~rst & ((sum == 3) | (state_0 & (sum == 2)));
end

always_ff @( posedge clk ) begin
        state_d <= sum; //ena & ~rst & ((sum == 3) | (state_0 & (sum == 2)));
end





endmodule