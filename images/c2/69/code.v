module mux2to1_enable (
    input A,
    input B,
    input EN,
    output Y
);

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNA ;

    assign Y = EN ? A : B;

endmodule