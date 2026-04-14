module top_module(
  input [n-1:0] a,
  input [n-1:0] b,
  output reg [2*n-1:0] result // Changed the output to 'reg' type
);parameter n = 8; // number of bits in the input and output signals
parameter signed_mode = 1; // 1 for signed multiplication, 0 for unsigned multiplication.

reg [2*n-1:0] signed_a, signed_b;
wire [2*n-1:0] signed_result;

assign signed_result = signed_a * signed_b;

always @(*) begin
  if (signed_mode == 1) begin
    signed_a = {{(n-1){a[n-1]}}, a}; // Sign extension for signed multiplication
    signed_b = {{(n-1){b[n-1]}}, b}; // Sign extension for signed multiplication
    result = signed_result; // Use the full size result
  end else begin
    result = {1'b0, a * b}; // Extend unsigned multiplication result
  end
end

endmodule