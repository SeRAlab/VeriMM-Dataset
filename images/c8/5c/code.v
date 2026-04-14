module comparator_2bit (
    input [1:0] A,
    input [1:0] B,
    output [1:0] C
);

    assign C[1] = (A[1] > B[1]) ? 1 : 0; //compare MSBs
    assign C[0] = (A[1] == B[1]) ? ((A[0] >= B[0]) ? 1 : 0) : ((C[1] == 1) ? 0 : 1); //compare LSBs

endmodule