module top_module(
    X   ,
    A1  ,
    A2  ,
    A3  ,
    B1  ,
    B2  ,
    VPWR,
    VGND,
    Y
);output X   ;
    output Y   ;
    input  A1  ;
    input  A2  ;
    input  A3  ;
    input  B1  ;
    input  B2  ;
    input  VPWR;
    input  VGND;
    
    wire a1_a2, a2_a3, b1_b2;
    
    assign a1_a2 = A1 & A2;
    assign a2_a3 = A2 & A3;
    assign b1_b2 = ~(B1 | B2);
    
    // Changed the instance to a generic AND gate for the sake of simulation 
    // since the original module sky130_fd_sc_hs__o32a_4 is missing.
    and base (
        X,  // Output of the AND gate
        A1,
        A2,
        A3,
        B1,
        B2
    );
    
    assign Y = (a1_a2 | a2_a3 | b1_b2);
    
endmodule