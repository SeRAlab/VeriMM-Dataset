module top_module(
  input clk,
  input reset,
  input [7:0] instruction,
  input [2:0] reg1_addr,
  input [2:0] reg2_addr,
  input [2:0] reg3_addr,
  input [15:0] reg1_data,
  input [15:0] reg2_data,
  input [15:0] reg3_data,
  output [15:0] reg1_out,
  output [15:0] reg2_out,
  output [15:0] reg3_out
);reg [5:0] state, next_state;
reg [1:0] opcode;
reg [2:0] rs1, rs2, rd;
reg [15:0] alu_result;
reg [7:0] instruction_reg;
reg [15:0] reg_file [0:7];

assign reg1_out = reg_file[reg1_addr];
assign reg2_out = reg_file[reg2_addr];
assign reg3_out = reg_file[reg3_addr];

parameter A = 6'b000001, B = 6'b000010, C = 6'b000100, D = 6'b001000, E = 6'b010000, F = 6'b100000;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    state <= A;
    // Initialize reg_file with zero values
    reg_file[0] <= 16'd0;
    reg_file[1] <= 16'd0;
    reg_file[2] <= 16'd0;
    reg_file[3] <= 16'd0;
    reg_file[4] <= 16'd0;
    reg_file[5] <= 16'd0;
    reg_file[6] <= 16'd0;
    reg_file[7] <= 16'd0;
  end else begin
    state <= next_state;
    instruction_reg <= instruction;
    
    case (state)
      A: begin
        opcode <= instruction_reg[7:6];
        rs1 <= instruction_reg[5:3];
        rs2 <= instruction_reg[2:0];
        rd <= instruction_reg[5:3];
        next_state <= B;
      end
      
      B: begin
        alu_result <= reg_file[rs1] + reg_file[rs2];
        next_state <= C;
      end
      
      C: begin
        reg_file[rd] <= alu_result;
        next_state <= D;
      end
      
      D: begin
        opcode <= instruction_reg[7:6];
        rs1 <= instruction_reg[5:3];
        rs2 <= instruction_reg[2:0];
        rd <= instruction_reg[5:3];
        next_state <= E;
      end
      
      E: begin
        case (opcode)
          2'b00: alu_result <= reg_file[rs1] & reg_file[rs2];
          2'b01: alu_result <= reg_file[rs1] | reg_file[rs2];
          2'b10: alu_result <= reg_file[rs1] ^ reg_file[rs2];
          2'b11: alu_result <= ~reg_file[rs1];
        endcase
        next_state <= F;
      end
      
      F: begin
        reg_file[rd] <= alu_result;
        next_state <= A;
      end
    endcase
  end
end

endmodule