module top_module(in0,in1,check,out);input wire [31:0] in0,in1;
input wire check;
output wire [31:0] out;
assign out=check==0?in0:in1;

endmodule