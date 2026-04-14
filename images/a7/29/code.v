module top_module(
 input [7:0] i,
 output [4:0] o1,
 output [2:0] o0
);assign o1 = i[7:3];
 assign o0 = i[2:0];
endmodule