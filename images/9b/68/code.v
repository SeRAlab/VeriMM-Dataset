module top_module(
    input A,
    input B,
    input C,
    input D,
    output X
);supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // If the module sky130_fd_sc_lp__or4_m is not found, replace it with the behavioral description
    assign X = A | B | C | D;

endmodule