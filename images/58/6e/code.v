module top_module(
    input [1:0] sel,
    input in0,
    input in1,
    input in2,
    input in3,
    output reg out
);wire int0, int1;
    assign int0 = (sel[0] == 1'b0) ? in0 : in1;
    assign int1 = (sel[0] == 1'b0) ? in2 : in3;
    assign out = (sel[1] == 1'b0) ? int0 : int1;

endmodule