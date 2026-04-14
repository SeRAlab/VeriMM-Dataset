module top_module(
 input i1,
 input [30:0] i0,
 output [31:0] o
);assign o = {i1, i0};
 
endmodule