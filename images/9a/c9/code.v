module top_module(
  input [n-1:0] a,
  input [n-1:0] b,
  input [1:0] mode,
  output [2*n-1:0] result,
  output overflow
);parameter n = 8; // number of bits in the input numbers
parameter algorithm = 2'b00; // algorithm to be used: Booth

reg [2*n-1:0] result_reg;
reg overflow_reg;

// Booth Algorithm
always @(*) begin
  if (mode == 2'b00) begin // unsigned multiplication
    result_reg = a * b;
    overflow_reg = (result_reg[n*2-1] == 1'b1);
  end else if (mode == 2'b01) begin // signed multiplication
    result_reg = $signed(a) * $signed(b);
    overflow_reg = (result_reg[n*2-1] != result_reg[n-1]);
  end else if (mode == 2'b10) begin // unsigned * signed multiplication
    result_reg = a * $signed(b);
    overflow_reg = (result_reg[n*2-1] == 1'b1);
  end else begin // not used
    result_reg = 0;
    overflow_reg = 0;
  end
end

assign result = result_reg;
assign overflow = overflow_reg;

endmodule