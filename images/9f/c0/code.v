module top_module(clk,
          ir_we, instr,
          opcode, reg1, reg2, reg3,
          sx16, zx16, hi16, sx16s2, sx26s2);input clk;
    input ir_we;
    input [31:0] instr;
    output [5:0] opcode;
    output [4:0] reg1;
    output [4:0] reg2;
    output [4:0] reg3;
    output [31:0] sx16;
    output [31:0] zx16;
    output [31:0] hi16;
    output [31:0] sx16s2;
    output [31:0] sx26s2;

  reg [31:0] ir;
  wire [15:0] copy_sign_16;	
  wire [3:0] copy_sign_26;	

  always @(posedge clk) begin
    if (ir_we) begin
      ir <= instr;
    end
  end

  assign opcode[5:0] = ir[31:26];
  assign reg1[4:0] = ir[25:21];
  assign reg2[4:0] = ir[20:16];
  assign reg3[4:0] = ir[15:11];
  assign copy_sign_16[15:0] = (ir[15] == 1) ? 16'hFFFF : 16'h0000;
  assign copy_sign_26[3:0] = (ir[25] == 1) ? 4'hF : 4'h0;
  assign sx16[31:0] = { copy_sign_16[15:0], ir[15:0] };
  assign zx16[31:0] = { 16'h0000, ir[15:0] };
  assign hi16[31:0] = { ir[15:0], 16'h0000 };
  assign sx16s2[31:0] = { copy_sign_16[13:0], ir[15:0], 2'b00 };
  assign sx26s2[31:0] = { copy_sign_26[3:0], ir[25:0], 2'b00 };

endmodule