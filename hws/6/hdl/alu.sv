`timescale 1ns/1ps
`default_nettype none

`include "alu_types.sv"

module alu(a, b, control, result, overflow, zero, equal);
parameter N = 32; // Don't need to support other numbers, just using this as a constant.

input wire [N-1:0] a, b; // Inputs to the ALU.
input alu_control_t control; // Sets the current operation.
output logic [N-1:0] result; // Result of the selected operation.

output logic overflow; // Is high if the result of an ADD or SUB wraps around the 32 bit boundary.
output logic zero;  // Is high if the result is ever all zeros.
output logic equal; // is high if a == b.

// Use *only* structural logic and previously defined modules to implement an 
// ALU that can do all of operations defined in alu_types.sv's alu_op_code_t.

logic [N-1:0] mux_in_and, mux_in_or, mux_in_xor, mux_in_sll,
              mux_in_srl, mux_in_sra,mux_in_add,mux_in_sub,
              mux_in_slt, mux_in_sltu;

logic add_c_out, sub_c_out, control_is_add, control_is_sub;
                  
mux16 select_type00(0, mux_in_and[0], mux_in_or[0],mux_in_xor[0], 
                    0, mux_in_sll[0], mux_in_srl[0],mux_in_sra[0], 
                    mux_in_add[0], 0, 0, 0, 0, mux_in_sub[0],mux_in_slt[0], mux_in_sltu[0], control, result[0]); 

mux16 select_type01(0, mux_in_and[1], mux_in_or[1],mux_in_xor[1], 
                    0, mux_in_sll[1], mux_in_srl[1],mux_in_sra[1], 
                    mux_in_add[1], 0, 0, 0, 0, mux_in_sub[1],mux_in_slt[1], mux_in_sltu[1], control, result[1]); 

mux16 select_type02(0, mux_in_and[2], mux_in_or[2],mux_in_xor[2], 
                    0, mux_in_sll[2], mux_in_srl[2],mux_in_sra[2], 
                    mux_in_add[2], 0, 0, 0, 0, mux_in_sub[2],mux_in_slt[2], mux_in_sltu[2], control, result[2]); 

mux16 select_type03(0, mux_in_and[3], mux_in_or[3],mux_in_xor[3], 
                    0, mux_in_sll[3], mux_in_srl[3],mux_in_sra[3], 
                    mux_in_add[3], 0, 0, 0, 0, mux_in_sub[3],mux_in_slt[3], mux_in_sltu[3], control, result[3]); 

mux16 select_type04(0, mux_in_and[4], mux_in_or[4],mux_in_xor[4], 
                    0, mux_in_sll[4], mux_in_srl[4],mux_in_sra[4], 
                    mux_in_add[4], 0, 0, 0, 0, mux_in_sub[4],mux_in_slt[4], mux_in_sltu[4], control, result[4]); 

mux16 select_type05(0, mux_in_and[5], mux_in_or[5],mux_in_xor[5], 
                    0, mux_in_sll[5], mux_in_srl[5],mux_in_sra[5], 
                    mux_in_add[5], 0, 0, 0, 0, mux_in_sub[5],mux_in_slt[5], mux_in_sltu[5], control, result[5]); 

mux16 select_type06(0, mux_in_and[6], mux_in_or[6],mux_in_xor[6], 
                    0, mux_in_sll[6], mux_in_srl[6],mux_in_sra[6], 
                    mux_in_add[6], 0, 0, 0, 0, mux_in_sub[6],mux_in_slt[6], mux_in_sltu[6], control, result[6]);                   

mux16 select_type07(0, mux_in_and[7], mux_in_or[7],mux_in_xor[7], 
                    0, mux_in_sll[7], mux_in_srl[7],mux_in_sra[7], 
                    mux_in_add[7], 0, 0, 0, 0, mux_in_sub[7],mux_in_slt[7], mux_in_sltu[7], control, result[7]); 

mux16 select_type08(0, mux_in_and[8], mux_in_or[8],mux_in_xor[8], 
                    0, mux_in_sll[8], mux_in_srl[8],mux_in_sra[8], 
                    mux_in_add[8], 0, 0, 0, 0, mux_in_sub[8],mux_in_slt[8], mux_in_sltu[8], control, result[8]); 

mux16 select_type09(0, mux_in_and[9], mux_in_or[9],mux_in_xor[9], 
                    0, mux_in_sll[9], mux_in_srl[9],mux_in_sra[9], 
                    mux_in_add[9], 0, 0, 0, 0, mux_in_sub[9],mux_in_slt[9], mux_in_sltu[9], control, result[9]);                

mux16 select_type10(0, mux_in_and[10], mux_in_or[10],mux_in_xor[10],
                    0, mux_in_sll[10], mux_in_srl[10],mux_in_sra[10], mux_in_add[10], 0, 0, 0, 0, mux_in_sub[10],mux_in_slt[10], mux_in_sltu[10], control, result[10]); 
                
mux16 select_type11(0, mux_in_and[11], mux_in_or[11],mux_in_xor[11],
                    0, mux_in_sll[11], mux_in_srl[11],mux_in_sra[11], mux_in_add[11], 0, 0, 0, 0, mux_in_sub[11],mux_in_slt[11], mux_in_sltu[11], control, result[11]); 

mux16 select_type12(0, mux_in_and[12], mux_in_or[12],mux_in_xor[12],
                    0, mux_in_sll[12], mux_in_srl[12],mux_in_sra[12], mux_in_add[12], 0, 0, 0, 0, mux_in_sub[12],mux_in_slt[12], mux_in_sltu[12], control, result[12]); 

mux16 select_type13(0, mux_in_and[13], mux_in_or[13],mux_in_xor[13],
                    0, mux_in_sll[13], mux_in_srl[13],mux_in_sra[13], mux_in_add[13], 0, 0, 0, 0, mux_in_sub[13],mux_in_slt[13], mux_in_sltu[13], control, result[13]); 

mux16 select_type14(0, mux_in_and[14], mux_in_or[14],mux_in_xor[14],
                    0, mux_in_sll[14], mux_in_srl[14],mux_in_sra[14], mux_in_add[14], 0, 0, 0, 0, mux_in_sub[14],mux_in_slt[14], mux_in_sltu[14], control, result[14]); 

mux16 select_type15(0, mux_in_and[15], mux_in_or[15],mux_in_xor[15],
                    0, mux_in_sll[15], mux_in_srl[15],mux_in_sra[15], mux_in_add[15], 0, 0, 0, 0, mux_in_sub[15],mux_in_slt[15], mux_in_sltu[15], control, result[15]); 


adder_n #(.N(N)) adder_32bit(a, b, 0, mux_in_add, add_c_out);
adder_n #(.N(N)) subtracter_32bit(a, -b, 0, mux_in_sub, sub_c_out);


always_comb begin : logic_outputs
    equal = ~|(a ^ b); // None of the XORs should be 1 if equal 
    zero = ~|(result); // True if none of the ORs are 1
    // Logic for overflow below
    control_is_add = ~|(control ^ 4'b1000);
    control_is_sub = ~|(control ^ 4'b1100);
    overflow = (control_is_add & add_c_out) | (control_is_sub & sub_c_out);
end

always_comb begin : mux_inputs
    mux_in_and = a & b;
    mux_in_or = a | b;
    mux_in_xor = a ^ b;
    mux_in_sll = 0;
    mux_in_srl = 0;
    mux_in_sra = 0;
    mux_in_add = 0;
    mux_in_sub = 0;
    mux_in_slt = 0;
    mux_in_sltu = 0;
end

always_comb begin : results
    result = 0;
end


endmodule