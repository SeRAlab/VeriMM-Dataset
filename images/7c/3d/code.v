module top_module(
    input  A  ,
    input  B  ,
    input  C  ,
    input  D_N,
    output Y
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;
    
    assign Y = ~(A | B | C | D_N);

endmodule