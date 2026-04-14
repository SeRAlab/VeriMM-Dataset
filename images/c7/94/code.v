module mux2to1 (
    input A1_N,
    input A2_N,
    input B1,
    input B2,
    output Y
);

    wire A1 = ~A1_N;
    wire A2 = ~A2_N;

    assign Y = (A1 & A2 & B2) | (A1 & ~A2 & B1) | (~A1 & A2 & B2) | (~A1 & ~A2 & B1);

endmodule