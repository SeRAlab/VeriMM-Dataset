module top_module(
    input A1,
    input A2,
    input A3,
    input B1,
    input B2,
    output X
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Combinational logic block
    assign X = (A1 & A2) | (A3 & B1) | (B1 & B2);

endmodule