module top_module(dataA,dataB,out);input [31:0] dataA, dataB;
output [31:0] out;

assign out = dataA * dataB;

endmodule