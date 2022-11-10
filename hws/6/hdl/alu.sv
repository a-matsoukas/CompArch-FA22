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
              mux_in_srl, mux_in_sra,mux_in_add, mux_in_sub,
              mux_in_slt, mux_in_sltu, mux_in_sll_0, mux_in_srl_0,
              mux_in_sra_0;

logic add_c_out, sub_c_out, control_is_add, control_is_sub;
                  
adder_n #(.N(N)) adder_32bit(a, b, 1'b0, mux_in_add, add_c_out);
adder_n #(.N(N)) subtracter_32bit(a, -b, 1'b0, mux_in_sub, sub_c_out);
shift_left_logical sll(a,b,mux_in_sll_0);
shift_right_logical srl(a,b,mux_in_srl_0);
shift_right_arithmetic sra(a,b,mux_in_sra_0);
slt less_than(a,b,mux_in_slt);
sltu less_than_unsigned(a,b,mux_in_sltu);

// Results mux
mux16 #(.N(32)) select(0, mux_in_and, mux_in_or,mux_in_xor, 0, mux_in_sll, mux_in_srl, mux_in_sra, mux_in_add, 0, 0, 0, mux_in_sub,mux_in_slt, 0, mux_in_sltu, control, result);

always_comb begin : logic_outputs
    equal = ~|(a ^ b); // None of the XORs should be 1 if equal 
    zero = ~|(result); // True if none of the ORs are 1
    // Logic for overflow below
    control_is_add = control[3] & ~|(control[2:0]);
    control_is_sub = &(control[3:2]) & ~|(control[1:0]);
    overflow = (control_is_add & add_c_out) | (control_is_sub & sub_c_out);
end

always_comb begin : mux_inputs
    mux_in_and = a & b;
    mux_in_or = a | b;
    mux_in_xor = a ^ b;
    mux_in_srl = &(~b[31:5]) ? mux_in_srl_0 : 32'b0;
    mux_in_sll = &(~b[31:5]) ? mux_in_sll_0 : 32'b0;
    mux_in_sra = &(~b[31:5]) ? mux_in_sra_0 : 32'b0;
end


endmodule