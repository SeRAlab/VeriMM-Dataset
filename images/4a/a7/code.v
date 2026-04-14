module top_module(
  input [n-1:0] A,
  input [n-1:0] B,
  input mode,
  input clk, // Added clk input
  output reg [2*n-1:0] P
);parameter n = 8; // number of bits in input integers

reg [n-1:0] multiplicand;
reg [n-1:0] multiplier;
reg [2*n-1:0] product;

always @(*) begin
  if (mode == 0) begin
    // Unsigned multiplication
    multiplicand = A;
    multiplier = B;
  end else begin
    // Signed multiplication
    multiplicand = $signed(A);
    multiplier = $signed(B);
  end
end

integer i;
always @(posedge clk) begin
  product = 0;
  for (i = 0; i < n; i = i + 1) begin
    if (multiplier[i]) begin
      product = product + (multiplicand << i);
    end
  end
  P = product;
end

endmodule