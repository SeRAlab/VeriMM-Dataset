module top_module(
  input clk,
  input rst,
  input signed [7:0] a,
  input signed [7:0] b,
  input [1:0] op,
  output signed [7:0] result
);reg [7:0] temp;

always @(posedge clk or negedge rst) begin
  if (!rst) begin
    temp <= 8'b0;
  end else begin
    case (op)
      2'b00: temp <= a + b; // Addition
      2'b01: temp <= a - b; // Subtraction
      2'b10: temp <= a * b; // Multiplication
      2'b11: temp <= a / b; // Division
    endcase
  end
end

assign result = temp;

endmodule