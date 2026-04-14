module top_module(
    input A1,
    input A2,
    input B1,
    output X
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;
    
    // Output logic
    assign X = (B1 == 1) ? (A1 & A2) : (A1 | A2);

endmodule