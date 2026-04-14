module top_module(op0, op1, select, result);input [31:0] op0, op1;
input select;
output [31:0] result;
assign result = select? op1: op0;
endmodule