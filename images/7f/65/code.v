module top_module(
  input [n-1:0] a,
  input [n-1:0] b,
  output gt,
  output eq,
  output lt
);parameter n = 4; // number of bits in input numbers

// Convert binary input numbers to signed integers
wire signed [n-1:0] a_signed = $signed(a);
wire signed [n-1:0] b_signed = $signed(b);

// Compare signed integers and set output signals
assign gt = (a_signed > b_signed) ? 1'b1 : 1'b0;
assign eq = (a_signed == b_signed) ? 1'b1 : 1'b0;
assign lt = (a_signed < b_signed) ? 1'b1 : 1'b0;

endmodule