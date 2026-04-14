module top_module(
    input  wire A0,
    input  wire A1,
    input  wire A2,
    input  wire A3,
    input  wire S0,
    input  wire S1,
    input  wire EN,
    output wire X
);wire sel0, sel1;
    
    assign sel0 = S0 & ~S1;
    assign sel1 = ~S0 & S1;
    
    assign X = (EN & ((sel0 & A0) | (sel1 & A1) | (S0 & S1 & A3) | (~S0 & ~S1 & A2))) ? X : 1'b0;

endmodule