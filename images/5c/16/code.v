module top_module(
    out ,
    A1  ,
    A2  ,
    B1  ,
    C1  
);// Module ports
    output out;
    input  A1;
    input  A2;
    input  B1;
    input  C1;

    // Module supplies
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Local signals
    wire or_out     ;
    wire nand_out   ;

    // Implement logic
    or   or_gate   (or_out  , A1, A2);
    nand nand_gate (nand_out, C1, or_out, B1);
    buf  buf_gate  (out     , nand_out);

endmodule