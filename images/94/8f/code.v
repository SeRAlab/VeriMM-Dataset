module top_module(
  input [3:0] in,
  output [1:0] out
);parameter p = 4; // number of product terms
parameter q = 2; // number of sum terms

// product terms
wire prod1 = in[0] & in[1];
wire prod2 = in[2] & ~in[3];
wire prod3 = in[0] & in[2] & ~in[3];
wire prod4 = in[1] & in[2] & in[3];

// sum terms
wire sum1 = prod1 | prod2;
wire sum2 = prod3 | prod4;

// output signals
assign out[0] = sum1;
assign out[1] = sum2;

endmodule