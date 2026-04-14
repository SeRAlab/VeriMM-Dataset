module top_module(
  input [n-1:0] A,
  input [n-1:0] B,
  output [n-1:0] P
);parameter n = 8; // number of bits in the input and output signals

// Unsigned multiplication
wire [2*n-1:0] unsigned_product;
assign unsigned_product = A * B;
assign P = unsigned_product[n-1:0];

// Signed multiplication using Booth's algorithm
wire [2*n-1:0] signed_product;
wire [n:0] signed_A;
wire [n:0] signed_B;
assign signed_A = {A[n-1], A};
assign signed_B = {B[n-1], B};
assign signed_product = signed_A * signed_B;
assign P = signed_product[n-1:0];

endmodule