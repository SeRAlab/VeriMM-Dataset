module top_module(
    Y,
    A1,
    A2,
    B1
);output Y;
    input A1;
    input A2;
    input B1;

    wire A1_AND_A2;
    wire B1_OR_A1_AND_A2;

    assign A1_AND_A2 = A1 & A2;
    assign B1_OR_A1_AND_A2 = B1 | A1_AND_A2;

    assign Y = B1_OR_A1_AND_A2;

endmodule