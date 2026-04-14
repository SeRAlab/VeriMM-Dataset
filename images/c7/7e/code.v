module nand4bb (
    input  A_N,
    input  B_N,
    input  C  ,
    input  D  ,
    output Y
);

    assign Y = ~(A_N & B_N & C & D);

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

endmodule