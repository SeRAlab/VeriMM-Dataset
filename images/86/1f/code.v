module top_module(
    output X,
    input  A,
    input  B,
    input  C
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    // Synthesize an OR3 gate using a behavioral description or instantiate
    // a valid equivalent if sky130_fd_sc_ls__or3 is not available.
    wire or_output;

    assign or_output = A | B | C;
    assign X = or_output;

endmodule