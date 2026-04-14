module top_module(input select, input [15:0]in1,in2, output [15:0]MuxOut);assign MuxOut = ~select ? in1 : in2;
endmodule