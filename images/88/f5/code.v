module top_module(
  input [2:0] operation,
  input [7:0] operand_a,
  input [7:0] operand_b,
  output reg [7:0] result,
  output reg overflow,
  output reg underflow
);always @* begin
    case(operation)
      3'b000: result = operand_a + operand_b;
      3'b001: result = operand_a - operand_b;
      3'b010: result = operand_a * operand_b;
      3'b011: result = operand_a / operand_b;
    endcase
    if(result > 255) begin
      overflow = 1;
      result = result % 256;
    end else begin
      overflow = 0;
    end
    if(operation == 3'b001 && operand_b > operand_a) begin
      underflow = 1;
    end else begin
      underflow = 0;
    end
  end
  
endmodule