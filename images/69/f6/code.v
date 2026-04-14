module top_module(input sel, input [4:0] in0, input [4:0] in1, output [4:0] out);assign out = sel ? in1 : in0;
endmodule