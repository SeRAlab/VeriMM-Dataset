module top_module(
  input [n*8-1:0] in,
  input [15:0] check,
  output reg error,
  output reg [15:0] out
);parameter n = 16; // number of input bytes

reg [15:0] A = 1;
reg [15:0] B = 1;

integer i;

always @(*) begin
  A = 1;
  B = 1;
  for (i = 0; i < n; i = i + 1) begin
    A = (A + in[i*8 +: 8]) % 65521;
    B = (B + A) % 65521;
  end
  out = (B << 16) | A;
end

always @(*) begin
  error = (out == check) ? 0 : 1;
end

endmodule