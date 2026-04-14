module top_module(subOut, in1, in2);output [7:0] subOut;
     input [7:0] in1;
     input [7:0] in2;
     
     assign subOut = in1 - in2;endmodule