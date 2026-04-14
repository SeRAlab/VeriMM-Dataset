module top_module(in1, in2, out1, out2);input [2:0] in1;
input       in2;

output      out1, out2;

wire out1, out2;

assign out1 = |{in1, in2};
assign out2 = ^in1;

endmodule