module top_module(
    output Y,
    input A1,
    input A2,
    input B1
);// Module supplies
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Local signals
    wire or_out;
    wire nand_out;

    //   Name   Output       Other arguments
    or   or_gate   (or_out    , A2, A1         );
    nand nand_gate (nand_out, B1, or_out    );
    buf  buffer    (Y         , nand_out    );

endmodule