module my_or3b_4 (
    input A,
    input B,
    input C_N,
    output X
);

    wire AB, AB_C_N, A_C_N, B_C_N;

    assign AB = A | B;
    assign AB_C_N = AB | C_N;
    assign A_C_N = A | C_N;
    assign B_C_N = B | C_N;

    assign X = AB_C_N & A_C_N & B_C_N;

endmodule