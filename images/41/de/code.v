module top_module(
    X   ,
    A   ,
    B   ,
    C   ,
    D   ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output X   ;
    input  A   ;
    input  B   ;
    input  C   ;
    input  D   ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    
    wire   AB, CD;

    // Logic combining inputs A, B, C, and D
    assign AB = A | B;  // Combine A and B
    assign CD = C | D;  // Combine C and D
    assign X = AB | CD; // Final OR combination

endmodule