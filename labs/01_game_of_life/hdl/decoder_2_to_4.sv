`timescale 1ns/1ps
module decoder_2_to_4(ena, in, out);

input wire ena;
input wire [1:0] in;
output logic [3:0] out;

logic [1:0] mid;

decoder_1_to_2 first_decoder(ena, in[1], mid);
decoder_1_to_2 second_decoder0(mid[0], in[0], out[1:0]);
decoder_1_to_2 second_decoder1(mid[1], in[0], out[3:2]);

endmodule
