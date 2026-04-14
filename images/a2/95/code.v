module top_module(
    input  A   ,
    input  B   ,
    input  CI  ,
    output COUT,
    output SUM
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    wire   W1, W2, W3;

    assign W1 = A ^ B;
    assign W2 = A & B;
    assign W3 = W2 & CI;

    assign SUM = W1 ^ CI;
    assign COUT = W3 | (W1 & CI);

endmodule