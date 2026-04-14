module top_module(
    input A1,
    input A2,
    input B1,
    input C1,
    input D1,
    output X
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    assign X = (A1 & A2) | (!A1 & B1) | (!C1 & D1);

endmodule