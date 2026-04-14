module top_module(
    input input1,
    input input2,
    input input3,
    input input4,
    output output1
);assign output1 = (input1 | input2 | input3 | input4) ? 1'b1 : 1'b0;

endmodule