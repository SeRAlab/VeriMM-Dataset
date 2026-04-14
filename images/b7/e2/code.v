module top_module(
  input [n-1:0] in,
  output [m-1:0] out
);parameter n = 4; // number of input signals
parameter m = 2; // number of output signals

// Priority encoder logic
assign out[0] = (in[0] == 1) ? 1 :
                (in[1] == 1) ? 2 :
                (in[2] == 1) ? 3 :
                (in[3] == 1) ? 4 : 0;
assign out[1] = (in[4] == 1) ? 5 :
                (in[5] == 1) ? 6 :
                (in[6] == 1) ? 7 :
                (in[7] == 1) ? 8 : 0;

// Binary encoder logic
assign out[0] = in[0] + in[1]*2 + in[2]*4 + in[3]*8;
assign out[1] = in[4] + in[5]*2 + in[6]*4 + in[7]*8;

endmodule