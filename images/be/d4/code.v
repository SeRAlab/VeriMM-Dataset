module top_module(
 input [31:0] i,
 output [16:0] o1,
 output [14:0] o0
);assign o1 = i[31:15];
 assign o0 = i[14:0];
endmodule