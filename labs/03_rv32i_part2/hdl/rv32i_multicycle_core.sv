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
enum logic [3:0] {S_FETCH, S_DECODE, S_MEM_ADDR, S_EXEC_R, S_EXEC_I, S_JAL, S_JALR, S_BRANCH, S_ALU_WRITEBACK,
                  S_MEM_READ, S_MEM_WRITE, S_JUMP_WRITEBACK, S_MEM_WRITEBACK} state;
op_type_t op_type;
funct3_ritype_t funct3_ritype;
logic [6:0] funct7_rtype, funct7_itype;
logic funct7_is_zeros;


//
logic [31:0] result, data, a, imm_ext, alu_out;
logic [11:0] imm;
logic [4:0] uimm;

// Control unit signals — PCWrite is PC_ena, MemWrite is mem_wr_ena (output), alu_control, & reg_write
logic ir_write_ena; // If enabled, update PC_OLD_REGISTER & INSTRUCTION_REGISTER  
//logic [1:0] imm_src; // ?? Controls extend


// Named MUXes
enum logic {MEM_SRC_PC, MEM_SRC_RESULT} mem_addr_src;
always_comb begin : memory_read_address_mux
  case(mem_addr_src)
    MEM_SRC_RESULT : mem_addr = result;
    MEM_SRC_PC     : mem_addr = PC;
    default : mem_addr = 0;
  endcase
end
enum logic [1:0] {SRC_A_SRC_PC, SRC_A_SRC_PC_OLD, SRC_A_SRC_A} ALU_src_a;
always_comb begin : ALU_src_a_mux
  case(ALU_src_a)
    SRC_A_SRC_PC     : src_a = PC;
    SRC_A_SRC_PC_OLD : src_a = PC_old;
    SRC_A_SRC_A      : src_a = a;
    default : src_a = 0;
  endcase
end
enum logic [1:0] {SRC_B_SRC_MEM_WRITE_DATA, SRC_B_SRC_EXTENTION, SRC_B_SRC_UIMM, SRC_B_SRC_4} ALU_src_b;
always_comb begin : ALU_src_b_mux
  case(ALU_src_b)
    SRC_B_SRC_MEM_WRITE_DATA : src_b = mem_wr_data;
    SRC_B_SRC_EXTENTION      : src_b = imm_ext;
    SRC_B_SRC_UIMM           : src_b = uimm;
    SRC_B_SRC_4              : src_b = 32'b100;
    default : src_b = 0;
  endcase
end
enum logic [1:0] {RESULT_SRC_ALU_OUT, RESULT_SRC_DATA, RESULT_SRC_ALU_RESULT} result_src;
always_comb begin : final_result_mux
  case(result_src)
    RESULT_SRC_ALU_OUT    : result = alu_out;
    RESULT_SRC_DATA       : result = data;
    RESULT_SRC_ALU_RESULT : result = alu_result;
    default : result = 0;
  endcase
end
enum logic [1:0] {IMM_SRC_I, IMM_SRC_S, IMM_SRC_B} imm_src;
always_comb begin : imm_mux
  case(imm_src)
    IMM_SRC_I : imm = instr[31:20];
    IMM_SRC_S : imm = {instr[31:25], instr[11:7]};
    IMM_SRC_B : imm = {instr[31], instr[7], instr[30:25], instr[11:8]}; // Check bc this is [12:1] not [11:0]
    default : imm = 0;
  endcase
end


always_comb begin : blockName
  rfile_wr_data = result;
  PC_next = result;
  funct7_is_zeros = ~|(funct7_rtype);
  imm_ext = (state == S_BRANCH) ? {{19{imm[11]}}, imm, 1'b0} : {{20{imm[11]}}, imm};
  uimm = imm[4:0];

  case (instr[6:0])
    OP_RTYPE : begin
      rs1 = instr[19:15];
      rs2 = instr[24:20];
      rd = instr[11:7];
      funct7_rtype = instr[31:25];
    end
    OP_ITYPE, OP_LTYPE : begin
      rs1 = instr[19:15];
      rd = instr[11:7];
      imm_src = IMM_SRC_I;
      funct7_itype = instr[31:25];
    end
    OP_STYPE : begin
      rs1 = instr[19:15];
      rs2 = instr[24:20];
      imm_src = IMM_SRC_S;
    end
    OP_BTYPE : begin
      rs1 = instr[19:15];
      rs2 = instr[24:20];
      imm_src = IMM_SRC_B;
    end
  endcase

  case (state)
      S_FETCH : begin
        mem_wr_ena = 0;
        reg_write = 0;
        PC_ena = 1;
        mem_addr_src = MEM_SRC_PC;
        ir_write_ena = 1;
        ALU_src_a = SRC_A_SRC_PC;
        ALU_src_b = SRC_B_SRC_4;
        alu_control = ALU_ADD;
        result_src = RESULT_SRC_ALU_RESULT;
      end
      S_DECODE : begin
        ir_write_ena = 0;
        PC_ena = 0;
      end
      S_EXEC_R : begin
        ALU_src_a = SRC_A_SRC_A;
        ALU_src_b = SRC_B_SRC_MEM_WRITE_DATA;
        case (instr[14:12]) // funct3_ritype
          FUNCT3_ADD : begin
            if (|(instr[31:25])) begin
              alu_control = ALU_SUB;
            end
            else begin
              alu_control = ALU_ADD;
            end
          end
          FUNCT3_SLL : alu_control = ALU_SLL;
          FUNCT3_SLT : alu_control = ALU_SLT;
          FUNCT3_SLTU : alu_control = ALU_SLTU;
          FUNCT3_XOR : alu_control = ALU_XOR;
          FUNCT3_SHIFT_RIGHT : begin
            if (|(instr[31:25])) begin
              alu_control = ALU_SRA;
            end
            else begin
              alu_control = ALU_SRL;
            end
          end
          FUNCT3_OR  : alu_control = ALU_OR;
          FUNCT3_AND : alu_control = ALU_AND;
        endcase
      end
      S_EXEC_I : begin
        ALU_src_a = SRC_A_SRC_A;
        case(instr[14:12])
          FUNCT3_SLL, FUNCT3_SHIFT_RIGHT : ALU_src_b = SRC_B_SRC_UIMM;
          default : ALU_src_b = SRC_B_SRC_EXTENTION;
        endcase

        case (instr[14:12]) //funct3_ritype
          FUNCT3_ADD : alu_control = ALU_ADD;
          FUNCT3_SLL : alu_control = ALU_SLL;
          FUNCT3_SLT : alu_control = ALU_SLT;
          FUNCT3_SLTU : alu_control = ALU_SLTU;
          FUNCT3_XOR : alu_control = ALU_XOR;
          FUNCT3_SHIFT_RIGHT : begin
            if (|(instr[31:25])) begin
              alu_control = ALU_SRA;
            end
            else begin
              alu_control = ALU_SRL;
            end
          end
          FUNCT3_OR  : alu_control = ALU_OR;
          FUNCT3_AND : alu_control = ALU_AND;
        endcase
      end

      S_MEM_ADDR : begin
        ALU_src_a = SRC_A_SRC_A;
        ALU_src_b = SRC_B_SRC_EXTENTION;
        alu_control = ALU_ADD;
      end

      S_MEM_READ : begin
        result_src = RESULT_SRC_ALU_OUT;
        mem_addr_src = MEM_SRC_RESULT;
      end

      S_MEM_WRITEBACK : begin
        result_src = RESULT_SRC_DATA;
        reg_write = 1;
      end

      S_MEM_WRITE : begin
        result_src = RESULT_SRC_ALU_OUT;
        mem_addr_src = MEM_SRC_RESULT;
        mem_wr_ena = 1;
      end

      S_ALU_WRITEBACK : begin
        result_src = RESULT_SRC_ALU_OUT;
        reg_write = 1;
      end

      S_BRANCH : begin
        ALU_src_a = SRC_A_SRC_A;
        ALU_src_b = SRC_B_SRC_MEM_WRITE_DATA;
        alu_control = ALU_SUB;
        result_src = RESULT_SRC_ALU_OUT;
        case(instr[14:12])
          FUNCT3_BEQ : begin
            if (zero) begin
              PC_ena = 1;
            end
          end
          FUNCT3_BNE : begin
            if (~zero) begin
              PC_ena = 1;
            end
          end
        endcase
      end
    endcase


end

always_ff @( posedge clk ) begin : control_unit_ff
  if (rst) begin
    state <= S_FETCH;
  end
  else if (ena) begin
    case (state)
      S_FETCH : begin
        state <= S_DECODE;
      end
      S_DECODE : begin
        case (instr[6:0])
          OP_RTYPE : state <= S_EXEC_R;
          OP_ITYPE : state <= S_EXEC_I;
          OP_LTYPE, OP_STYPE : state <= S_MEM_ADDR;
          OP_BTYPE : state <= S_BRANCH;
        endcase
      end
      S_MEM_ADDR : begin
        case(instr[6:0])
          OP_LTYPE : state <= S_MEM_READ;
          OP_STYPE : state <= S_MEM_WRITE;
        endcase
      end
      S_EXEC_R        : state <= S_ALU_WRITEBACK;
      S_EXEC_I        : state <= S_ALU_WRITEBACK;
      S_MEM_READ      : state <= S_MEM_WRITEBACK;
      S_MEM_WRITE     : state <= S_FETCH;
      S_MEM_WRITEBACK : state <= S_FETCH;
      S_ALU_WRITEBACK : state <= S_FETCH;
      S_BRANCH        : state <= S_FETCH;
    endcase
  end
end

endmodule
