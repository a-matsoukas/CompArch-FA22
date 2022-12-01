`timescale 1ns/1ps
`default_nettype none

`include "alu_types.sv"
`include "rv32i_defines.sv"

module rv32i_multicycle_core(
  clk, rst, ena,
  mem_addr, mem_rd_data, mem_wr_data, mem_wr_ena,
  PC
);

parameter PC_START_ADDRESS=0;

// Standard control signals.
input  wire clk, rst, ena; // <- worry about implementing the ena signal last.

// Memory interface.
output logic [31:0] mem_addr, mem_wr_data;
input   wire [31:0] mem_rd_data;
output logic mem_wr_ena;

// Program Counter
output wire [31:0] PC;
wire [31:0] PC_old;
logic PC_ena; // AKA PCWrite
logic [31:0] PC_next; 

// Program Counter Registers
register #(.N(32), .RESET(PC_START_ADDRESS)) PC_REGISTER (
  .clk(clk), .rst(rst), .ena(PC_ena), .d(PC_next), .q(PC)
);
register #(.N(32)) PC_OLD_REGISTER(
  .clk(clk), .rst(rst), .ena(ir_write_ena), .d(PC), .q(PC_old)
);
register #(.N(32)) INSTRUCTION_REGISTER(
  .clk(clk), .rst(rst), .ena(ir_write_ena), .d(mem_rd_data), .q(instr)
);
register #(.N(32)) SMALL_DATA_REGISTER(
  .clk(clk), .rst(rst), .ena(1'b1), .d(mem_rd_data), .q(data)
);
register #(.N(32)) RD1_REGISTER(
  .clk(clk), .rst(rst), .ena(1'b1), .d(reg_data1), .q(a)
);
register #(.N(32)) RD2_REGISTER(
  .clk(clk), .rst(rst), .ena(1'b1), .d(reg_data2), .q(mem_wr_data)
);
register #(.N(32)) RESULT_REGISTER(
  .clk(clk), .rst(rst), .ena(1'b1), .d(alu_result), .q(alu_out)
);

//  an example of how to make named inputs for a mux:
/*
    enum logic {MEM_SRC_PC, MEM_SRC_RESULT} mem_src;
    always_comb begin : memory_read_address_mux
      case(mem_src)
        MEM_SRC_RESULT : mem_rd_addr = alu_result;
        MEM_SRC_PC : mem_rd_addr = PC;
        default: mem_rd_addr = 0;
    end
*/

// Register file
logic reg_write;
logic [4:0] rd, rs1, rs2;
logic [31:0] rfile_wr_data;
wire [31:0] reg_data1, reg_data2;
register_file REGISTER_FILE(
  .clk(clk), 
  .wr_ena(reg_write), .wr_addr(rd), .wr_data(rfile_wr_data),
  .rd_addr0(rs1), .rd_addr1(rs2),
  .rd_data0(reg_data1), .rd_data1(reg_data2)
);

// ALU and related control signals
// Feel free to replace with your ALU from the homework.
logic [31:0] src_a, src_b;
alu_control_t alu_control;
wire [31:0] alu_result;
wire overflow, zero, equal;
alu_behavioural ALU (
  .a(src_a), .b(src_b), .result(alu_result),
  .control(alu_control),
  .overflow(overflow), .zero(zero), .equal(equal)
);

// Implement your multicycle rv32i CPU here!
logic [31:0] instr;
enum logic [1:0] {S_FETCH, S_DECODE, S_EXEC_R, S_ALU_WRITEBACK} state;
op_type_t op_type;
funct3_ritype_t funct3_ritype;
logic [6:0] funct7_rtype;
logic funct7_is_zeros;


//
logic [31:0] result, data, a, imm_ext, alu_out;

// Control unit signals — PCWrite is PC_ena, MemWrite is mem_wr_ena (output), alu_control, & reg_write
logic addr_src; // 0 if PC is mem_addr, 1 if result is mem_addr
logic ir_write_ena; // If enabled, update PC_OLD_REGISTER & INSTRUCTION_REGISTER  
logic [1:0] result_src; // Chooses result: 00 (ALUOut), 01 (Data (from rd_data)), 10 (ALUResult)
logic [1:0] ALU_src_a, ALU_src_b; // See diagram
logic [1:0] imm_src; // ?? Controls extend

mux4 #(.N(32)) ALU_src_a_mux(PC, PC_old, a, 0, ALU_src_a, src_a);
mux4 #(.N(32)) ALU_src_b_mux(mem_wr_data, imm_ext, 32'b100, 0, ALU_src_b, src_b);
mux4 #(.N(32)) final_result_mux(alu_out, data, alu_result, 0, result_src, result);


always_comb begin : blockName
  mem_addr = addr_src ? PC : result;
  rfile_wr_data = result;
  PC_next = result;
  funct7_is_zeros = ~|(funct7_rtype);
end


always_ff @( posedge clk ) begin : control_unit_ff
  if (rst) begin
    state <= S_FETCH;
  end
  else if (ena) begin
    case (state)
      S_FETCH : begin
        addr_src <= 0;
        ir_write_ena <= 1;
        ALU_src_a <= 2'b00;
        ALU_src_b <= 2'b10;
        alu_control <= ALU_ADD;
        result_src <= 2'b10;
        PC_ena <= 1;
        state <= S_DECODE;
      end
      S_DECODE : begin
        PC_ena <= 0;
        op_type <= instr[6:0];
        case (op_type)
          OP_RTYPE : begin
            rs1 <= instr[19:15];
            rs2 <= instr[24:20];
            rd <= instr[11:7];
            funct3_ritype <= instr[14:12];
            funct7_rtype <= instr[31:25];
            state <= S_EXEC_R;
          end
        endcase
      end
      S_EXEC_R : begin
        case (funct3_ritype)
          FUNCT3_ADD : alu_control <= funct7_is_zeros ? ALU_ADD : ALU_SUB;
        endcase
        state <= S_ALU_WRITEBACK;
      end
      S_ALU_WRITEBACK : begin
        rfile_wr_data <= alu_result;
      end
    endcase
  end
end

endmodule
