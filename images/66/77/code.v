module top_module(
    input input1,
    input input2,
    input input3,
    output output1
);wire intermediate1;
    wire intermediate2;

    and and1 (intermediate1, input1, input2);
    and and2 (intermediate2, intermediate1, input3);
    not not1 (output1, intermediate2);

endmodule