module top_module(
    Y   ,
    A1  ,
    A2  ,
    B1  ,
    B2  ,
    VPWR,
    VGND,
    VPB ,
    VNB
);output Y   ;
    input  A1  ;
    input  A2  ;
    input  B1  ;
    input  B2  ;
    input  VPWR;
    input  VGND;
    input  VPB ;
    input  VNB ;

    // Check if the module sky130_fd_sc_hd__o22ai is included in your library.
    // If not, ensure you have the correct library files or change the instance to an available module in your environment.

    // Assuming sky130_fd_sc_hd__o22ai is unavailable, you can replace it with a logic equivalent
    // Here is an alternative implementation using basic gates (AND, OR, NOT) if the specific module isn't available
    wire nA1, nA2, nB1, nB2, and1, and2;

    not (nA1, A1);
    not (nA2, A2);
    not (nB1, B1);
    not (nB2, B2);
    
    and (and1, A1, A2);
    and (and2, B1, B2);
    
    or (Y, and1, and2);

endmodule