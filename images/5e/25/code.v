module top_module(
  input in,
  input [n-1:0] sel,
  output [2**n-1:0] out
);parameter n = 3; // number of control signals

assign out[0] = sel == 0 ? in : 0;
assign out[1] = sel == 1 ? in : 0;
assign out[2] = sel == 2 ? in : 0;
assign out[3] = sel == 3 ? in : 0;
assign out[4] = sel == 4 ? in : 0;
assign out[5] = sel == 5 ? in : 0;
assign out[6] = sel == 6 ? in : 0;
assign out[7] = sel == 7 ? in : 0;

endmodule