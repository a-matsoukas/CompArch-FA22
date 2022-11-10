`timescale 1ns/1ps
module decoder_5_to_32(ena, in, out);

  input wire ena;
  input wire [4:0] in;
  output logic [31:0] out;

  logic [3:0] mid;

  decoder_2_to_4 first_decoder(ena,in[4:3],mid);
  decoder_3_to_8 second_decoder0(mid[0], in[2:0], out[7:0]);
  decoder_3_to_8 second_decoder1(mid[1], in[2:0], out[15:8]);
  decoder_3_to_8 second_decoder2(mid[2], in[2:0], out[23:16]);
  decoder_3_to_8 second_decoder3(mid[3], in[2:0], out[31:24]);

endmodule