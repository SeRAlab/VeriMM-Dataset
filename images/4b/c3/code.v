module top_module(
    input A,
    output X
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    // Internal signals
    wire Z1, Z2, Z3;

    // Buffer: Use a simple buffer if the original is not found
    assign Z1 = A; // Replacing sky130_fd_sc_lp__buf_1 with a simple assignment
    assign Z2 = Z1;
    assign Z3 = Z2;
    assign X = Z3;

endmodule