module top_module(
  input [n-1:0] numerator,
  input [n-1:0] denominator,
  output reg [n-1:0] remainder // Changed 'output' to 'output reg'
);parameter n = 8; // number of bits for numerator and denominator.

reg [n-1:0] quotient;
reg [n-1:0] dividend;

always @(*) begin
  if (denominator == 0) begin
    remainder = 0;
  end
  else if (numerator < denominator) begin
    remainder = numerator;
  end
  else begin
    quotient = numerator / denominator;
    dividend = quotient * denominator;
    remainder = numerator - dividend;
  end
end

endmodule