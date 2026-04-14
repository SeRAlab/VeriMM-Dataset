module top_module(
    //# {{data|Data Signals}}
    input  A_N,
    input  B_N,
    input  C  ,
    input  D  ,
    output X
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;
    
    // AND gate implementation
    assign X = ~(A_N | B_N | C | D);

endmodule