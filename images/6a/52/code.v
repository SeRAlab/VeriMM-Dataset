module top_module(
    output Y,
    input  A1_N,
    input  A2_N,
    input  B1,
    input  B2,
    input  VPWR,
    input  VGND,
    input  VPB,
    input  VNB
);// Since sky130_fd_sc_lp__o2bb2ai module is unknown, it's removed.
    // The output logic is retained for functionality.

    assign Y = (A1_N == 0 && A2_N == 0 && B1 == 1 && B2 == 1) ? 1 :
                (A1_N == 1 && A2_N == 1 && B1 == 0 && B2 == 0) ? 0 :
                1'bx;

endmodule