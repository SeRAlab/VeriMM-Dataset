module top_module(
  input [n-1:0] A,
  input [n-1:0] B,
  input ctrl,
  output reg [2*n-1:0] P
);parameter n = 4; // number of bits

reg [2*n-1:0] product;
reg signed [n-1:0] signed_A;
reg signed [n-1:0] signed_B;
reg signed [2*n-1:0] signed_product;

integer i; // Declare i as an integer

always @(*) begin
  if (ctrl == 0) begin // unsigned multiplication
    product = {2*n{1'b0}}; // initialize product to 0, corrected to use 2*n
    for (i = 0; i < n; i = i + 1) begin
      if (B[i] == 1'b1) begin
        product = product + (A << i);
      end
    end
    P = product;
  end
  else begin // signed multiplication
    signed_A = $signed(A);
    signed_B = $signed(B);
    signed_product = signed_A * signed_B;
    P = signed_product; // use the full signed_product without sign extension
  end
end

endmodule