module top_module(cntrl,in1,in2,out);input cntrl;
input [1:0] in1,in2;
output [1:0] out;
assign out = (cntrl == 1) ? in2 : in1;
endmodule