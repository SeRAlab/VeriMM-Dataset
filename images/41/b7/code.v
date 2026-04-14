module top_module(
    input  A1,
    input  A2,
    input  B1,
    input  C1,
    input  D1,
    output X
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;
    
    assign X = (A1 & A2) ? 1 : // If A1 and A2 are both 1, X should be 1.
               (A1 & ~A2) ? 0 : // If A1 is 1 and A2 is 0, X should be 0.
               (~A1 & A2 & B1 & ~C1) ? 1 : // If A1 is 0 and A2 is 1, X should be 1 if B1 is 1 and C1 is 0, and 0 otherwise.
               (~A1 & A2 & B1 & C1) ? 0 : // If A1 is 0 and A2 is 1, X should be 1 if B1 is 1 and C1 is 1, and 0 otherwise.
               (D1) ? 1 : 0; // If D1 is 1, X should be 1 regardless of the other input signals.

endmodule