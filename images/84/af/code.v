module top_module(op, r1, r2, r3, HRDATA, clk, reset);output [0:3] op, r1, r2, r3;
input [0:15] HRDATA;
input clk, reset;
assign {op, r1, r2, r3} = HRDATA;endmodule