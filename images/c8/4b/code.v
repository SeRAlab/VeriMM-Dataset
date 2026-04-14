module and4_module (
    input A,
    input B,
    input C,
    input D,
    output X
);

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    assign X = A & B & C & D;

endmodule