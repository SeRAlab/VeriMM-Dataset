module top_module(
  input [n-1:0] num1,
  input [n-1:0] num2,
  output reg [1:0] out
);parameter n = 4; // number of bits in the binary numbers

always @(*) begin
  if (num1 > num2) begin
    out[1] = 1; // gt
    out[0] = 0; // lt
  end else if (num1 < num2) begin
    out[1] = 0; // gt
    out[0] = 1; // lt
  end else begin
    out[1] = 0; // gt
    out[0] = 0; // lt
  end
end

endmodule