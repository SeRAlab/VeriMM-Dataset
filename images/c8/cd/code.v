module xnor3_2 (
    input A,
    input B,
    input C,
    output X
);

    wire AB_xor = A ^ B;
    wire ABC_xor = AB_xor ^ C;
    wire ABC_xor_not = ~ABC_xor;
    assign X = ABC_xor_not;

endmodule