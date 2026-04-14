module top_module(
    input  A1_N,
    input  A2_N,
    input  B1  ,
    input  B2  ,
    output X
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Implementation of the module
    wire A1 = ~A1_N;
    wire A2 = ~A2_N;
    wire B = B1 & B2;
    wire Y1 = A1 & B;
    wire Y2 = A2 & B;
    wire Y = Y1 | Y2;
    assign X = ~Y;

endmodule