module full_adder (
    input  A   ,
    input  B   ,
    input  CIN ,
    output COUT,
    output SUM
);

    assign SUM = A ^ B ^ CIN;
    assign COUT = (A & B) | (A & CIN) | (B & CIN);

endmodule