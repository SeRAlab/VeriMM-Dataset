module magnitude_comparator (
    input [3:0] A,
    input [3:0] B,
    output AGTB,
    output ALTB,
    output AEQB
);
    assign AGTB = (A > B);
    assign ALTB = (A < B);
    assign AEQB = (A == B);
endmodule