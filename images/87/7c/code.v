module top_module(
    input input1,
    input input2,
    input input3,
    input input4,
    input input5,
    output output1
);wire and1, and2, and3, and4, or1;

    assign and1 = input1 & input2;
    assign and2 = input3 & input4;
    assign and3 = and2 & input5;
    assign or1 = and1 | and3;
    assign output1 = or1;

endmodule