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
logic c_out;

logic [35:0] sum_memory;
assign sum_memory[3:0] = 4'b0;
assign sum[3:0] = sum_memory[35:32];

wire [7:0] carries_out;

generate
    genvar i;
    for(i = 0; i < 8; i++) begin : generated_conway_adders
        adder_n #(.N(4)) adder_4bit (
            .a(sum_memory[i*4 + 3 : i*4]),
            .b({3'b0, neighbors[i]}),
            .c_in(1'b0),
            .sum(sum_memory[(i + 1)*4 + 3 : (i + 1)*4]),
            .c_out(carries_out[i]));
    end
endgenerate

logic sum_is_2, sum_is_3;

always_comb begin
    sum_is_3 = &({~sum[3], ~sum[2], sum[1], sum[0]});
    sum_is_2 = &({~sum[3], ~sum[2], sum[1], ~sum[0]});
    state_d = ena ? (sum_is_3 | (state_q & sum_is_2)) : state_q;
end

always_ff @( posedge clk ) begin
    state_q <= rst ? state_0 : state_d;
end





endmodule