module bitwise_and (
    input [7:0] A,
    input [7:0] B,
    output [7:0] C
);

    wire [7:0] and_result;

    // AND gates for each bit
    and and0(and_result[0], A[0], B[0]);
    and and1(and_result[1], A[1], B[1]);
    and and2(and_result[2], A[2], B[2]);
    and and3(and_result[3], A[3], B[3]);
    and and4(and_result[4], A[4], B[4]);
    and and5(and_result[5], A[5], B[5]);
    and and6(and_result[6], A[6], B[6]);
    and and7(and_result[7], A[7], B[7]);

    assign C = and_result;

endmodule