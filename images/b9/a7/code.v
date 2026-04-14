module top_module(
  output reg [7:0] result,
  input [7:0] operand1,
  input [7:0] operand2,
  input [1:0] select,
  input clk  // Added clk input
);always @ (posedge clk) begin
    case (select)
      2'b00: result <= operand1 + operand2;
      2'b01: result <= operand1 - operand2;
      2'b10: result <= operand1 & operand2;
      2'b11: result <= operand1 | operand2;
      default: result <= 8'd0; // Added default case for safety
    endcase
  end

endmodule