module sky130_fd_sc_ms__nor3 (
    input  A,
    input  B,
    input  C,
    output Y
);

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    assign Y = ~(A | B | C);

endmodule