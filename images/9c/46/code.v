module top_module(
  input         rst,
  input         clk,
  input  [7:0]  a,
  input  [7:0]  b,
  input  [1:0]  op,
  output [7:0]  result,
  output        valid
);reg [7:0] result_reg;
  reg valid_reg;

  always @(posedge clk or negedge rst) begin
    if (rst == 0) begin
      result_reg <= 0;
      valid_reg <= 0;
    end
    else begin
      case(op)
        2'b00: result_reg <= a + b; // addition
        2'b01: result_reg <= a - b; // subtraction
        2'b10: result_reg <= a * b; // multiplication
        2'b11: result_reg <= a / b; // division
      endcase
      valid_reg <= 1;
    end
  end

  assign result = result_reg;
  assign valid = valid_reg;

endmodule