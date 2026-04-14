module top_module(
    Y   ,
    A1_N,
    A2_N,
    B1  ,
    B2
);output Y   ;
    input  A1_N;
    input  A2_N;
    input  B1  ;
    input  B2  ;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Assuming sky130_fd_sc_lp__o2bb2ai is correctly defined somewhere else
    // It might refer to another module that needs to be included in the project
    // Change the instance name and connection here if the module is available.
    
    // Uncomment below line once the module definition is available
    // sky130_fd_sc_lp__o2bb2ai base (
    //     .Y(Y),
    //     .A1_N(A1_N),
    //     .A2_N(A2_N),
    //     .B1(B1),
    //     .B2(B2)
    // );

    // Use the logic expression directly instead
    assign Y = ~(A1_N & A2_N & B1 & ~B2) & ~(A1_N & ~A2_N & ~B1 & B2) & 
               ~(~A1_N & A2_N & ~B1 & B2) & ~(~A1_N & ~A2_N & B1 & B2);

endmodule