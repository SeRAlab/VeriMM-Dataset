module bitwise_xor(
  input [7:0] a,
  input [7:0] b,
  output reg [7:0] result
);

  always @ (a or b) begin
    result = a ^ b;
  end

endmodule