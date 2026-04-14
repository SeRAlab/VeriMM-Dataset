module top_module(
 input  signed [2:0] din1,
 input  signed [2:0] din2,
 output signed [5:0] dout);assign dout = din1 * din2;

endmodule