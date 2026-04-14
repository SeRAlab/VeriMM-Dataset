module top_module(
    input A1,
    input A2,
    input B1,
    input C1,
    output X
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // AND gate logic
    assign X = A1 & A2 & B1 & C1;

endmodule