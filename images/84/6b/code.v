module top_module(
    input A,
    input B,
    input C_N,
    output Y
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    assign Y = ~(A | B | C_N);

endmodule