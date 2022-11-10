`timescale 1ns/1ps
module decoder_3_to_8(ena, in, out);

  input wire ena;
  input wire [2:0] in;
  output logic [7:0] out;

  logic [1:0] mid;

  decoder_1_to_2 first_decoder(ena,in[2],mid);
  decoder_2_to_4 second_decoder0(mid[0], in[1:0], out[3:0]);
  decoder_2_to_4 second_decoder1(mid[1], in[1:0], out[7:4]);

endmodule