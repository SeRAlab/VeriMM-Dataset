module XOR_8(
  input [7:0] A,
  input [7:0] B,
  output reg [7:0] Z
);

  always @* begin
    Z = A ^ B;
  end

endmodule