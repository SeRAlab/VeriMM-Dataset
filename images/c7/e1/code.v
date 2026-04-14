module modulo_operator (
  input [31:0] dividend,
  input [31:0] divisor,
  output reg [31:0] remainder
);

always @(*) begin
  if (divisor == 0) begin
    remainder = 0;
  end else begin
    remainder = dividend % divisor;
  end
end

endmodule