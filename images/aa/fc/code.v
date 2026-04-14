module top_module(
    input [3:0] in0,
    input [3:0] in1,
    input [3:0] in2,
    input [3:0] in3,
    input s0,
    input s1,
    output [3:0] out
);wire [3:0] w1, w2;

assign w1 = s0 ? in2 : in0;
assign w2 = s0 ? in3 : in1;

assign out = s1 ? w2 : w1;

endmodule