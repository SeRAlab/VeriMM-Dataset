module top_module(
    Y,
    A1,
    A2,
    B1,
    B2
);output Y;
    input A1;
    input A2;
    input B1;
    input B2;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    assign Y = ((A1 & A2 == 0) & (B1 == 1 & B2 == 1)) | ((A1 == 1 & A2 == 0) & (B1 == 0 & B2 == 0)) | ((A1 == 0 & A2 == 1) & (B1 == 0 & B2 == 0)) | ((A1 & A2 == 1) & (B1 == 0 & B2 == 0));

endmodule