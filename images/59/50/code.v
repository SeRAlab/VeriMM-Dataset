module top_module(
  input [n-1:0] a,
  input [n-1:0] b,
  output greater
);parameter n = 8; // number of bits in input signals

reg signed [n-1:0] a_signed;
reg signed [n-1:0] b_signed;

assign greater = (a_signed > b_signed);

always @(*) begin
  a_signed = $signed(a);
  b_signed = $signed(b);
end

endmodule