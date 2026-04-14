module top_module(
  input [31:0] A,
  input [31:0] B,
  output reg [31:0] Remainder
);always @(*) begin
    Remainder = A - (B * (A / B));
  end

endmodule