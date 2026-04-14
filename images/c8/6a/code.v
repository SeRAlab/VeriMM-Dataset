module and4 (
    input A,
    input B,
    input C,
    input D,
    output X
);

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    assign X = A & B & C & D;

endmodule