module logic_module (
    input A1,
    input A2,
    input B1,
    input B2,
    output Y
);

    assign Y = (A1 & A2) | ((A1 & ~B1 & ~B2) & ~(A2 | B1 | B2)) | (~A1 & ~A2 & B1 & B2);

endmodule