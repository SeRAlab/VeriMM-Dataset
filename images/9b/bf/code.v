module top_module(
  input [31:0] a,
  input [31:0] b,
  input [1:0] operation_select,
  input [4:0] shift_amount,
  input clk,            // Add the clock input
  output reg [31:0] result // Change to reg type since it is assigned in an always block
);// Pipeline registers
  reg [31:0] a_reg1, a_reg2, a_reg3;
  reg [31:0] b_reg1, b_reg2, b_reg3;
  reg [1:0] op_reg1, op_reg2, op_reg3;
  reg [4:0] shift_reg1, shift_reg2, shift_reg3;
  
  // Stage 1
  always @(*) begin
    a_reg1 = a;
    b_reg1 = b;
    op_reg1 = operation_select;
    shift_reg1 = shift_amount;
  end
  
  // Stage 2
  always @(posedge clk) begin
    a_reg2 <= a_reg1;  // Use non-blocking assignments for sequential logic
    b_reg2 <= b_reg1;
    op_reg2 <= op_reg1;
    shift_reg2 <= shift_reg1;
  end
  
  // Stage 3
  always @(posedge clk) begin
    a_reg3 <= a_reg2;
    b_reg3 <= b_reg2;
    op_reg3 <= op_reg2;
    shift_reg3 <= shift_reg2;
  end
  
  // Stage 4
  always @(posedge clk) begin
    case(op_reg3)
      2'b00: result <= a_reg3 & b_reg3; // AND
      2'b01: result <= a_reg3 | b_reg3; // OR
      2'b10: result <= a_reg3 ^ b_reg3; // XOR
      2'b11: result <= a_reg3 << shift_reg3; // Shift left
      default: result <= 32'b0; // Add default case to avoid latches
    endcase
  end
  
endmodule