module top_module(
    input [3:0] in0,
    input [3:0] in1,
    output EQ,
    output GT
);assign EQ = (in0 == in1) ? 1'b1 : 1'b0;
    assign GT = (in0 > in1) ? 1'b1 : 1'b0;

endmodule