module top_module(
  input [n-1:0] A,
  input [n-1:0] B,
  input mode,
  output reg signed [2*n-1:0] P
);parameter n = 4; // number of bits for A and B

reg signed [2*n-1:0] A_signed, B_signed;

always @(*) begin
  if (mode) begin
    // Signed multiplication
    A_signed = $signed(A);
    B_signed = $signed(B);
    P = A_signed * B_signed;
  end else begin
    // Unsigned multiplication
    P = A * B;
  end
end

endmodule