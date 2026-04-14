module top_module(input [1:0] a, output [2:0] o);assign o[0] = ^a;
assign o[1] = ~o[0];
assign o[2] = o[1];
endmodule