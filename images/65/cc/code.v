module top_module(
    input  A1  ,
    input  A2  ,
    input  B1  ,
    input  C1  ,
    output Y   ,
    input  VPB ,
    input  VPWR,
    input  VGND,
    input  VNB
);// Rule 1: If A1 is high and A2 is low, Y should be equal to B1.
    assign Y = (A1 && !A2) ? B1 :
    
    // Rule 2: If A1 is low and A2 is high, Y should be equal to C1.
               (!A1 && A2) ? C1 :
    
    // Rule 3: If both A1 and A2 are high, Y should be equal to B1 and C1 ORed together.
               (A1 && A2) ? (B1 | C1) :
    
    // Rule 4: If both A1 and A2 are low, Y should be set to 0.
               0;

endmodule