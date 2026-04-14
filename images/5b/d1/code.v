module top_module(input [7:0] in1,in2,output [7:0] out, input sel
    );assign out = sel? in2:in1;

endmodule