module top_module(
    input  A_N,
    input  B  ,
    input  C  ,
    output X
);wire nA;
    wire nB;
    wire nC;

    assign nA = ~A_N;
    assign nB = ~B;
    assign nC = ~C;

    wire nAB;
    wire nBC;
    wire nAC;

    assign nAB = nA & nB;
    assign nBC = nB & nC;
    assign nAC = nA & nC;

    wire nABC;

    assign nABC = nAB & nBC & nAC;

    assign X = ~nABC;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

endmodule