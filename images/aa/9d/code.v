module top_module(
    Y   ,
    A   ,
    B   ,
    C   ,
    D_N ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output Y   ;
    input  A   ;
    input  B   ;
    input  C   ;
    input  D_N ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;
    
    wire nor1_out;
    wire nor2_out;
    wire nor3_out;
    
    // Assuming sky130_fd_sc_hd__nor4b_4 is a valid NOR gate with 4 inputs and 1 negated input
    // Ensure that the module definition is included in the design or appropriately replaced with known gates
    nor nor1 (
        nor1_out,
        VPWR,  // Changed order per standard NOR gate definition
        A,
        B,
        1'b1   // Assuming D is pulled to logic high
    );
    
    nor nor2 (
        nor2_out,
        VPWR,  // Similarly changed this order for consistency
        C,
        D_N,
        1'b1   // Assuming a high logic for the negated input
    );
    
    nor nor3 (
        Y,
        VPWR,  // Changed order per standard NOR gate definition
        nor1_out,
        nor2_out,
        1'b1   // Assuming a high logic for the last input
    );

endmodule