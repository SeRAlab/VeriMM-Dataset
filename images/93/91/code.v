module top_module(
    input A,
    input B,
    input C,
    input D,
    output X,
    input VPWR,
    input VGND,
    input VPB,
    input VNB
);// Instance of a standard AND gate with four inputs
    // Replace sky130_fd_sc_lp__and4 with a behavioral description if the library is not found
    assign X = A & B & C & D;

endmodule