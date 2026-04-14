module top_module(
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    input [3:0] D,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output X
);wire [3:0] AB;
    wire [3:0] CD;

    assign AB = A | B;
    assign CD = C | D;
    assign X = |(AB | CD); // Simplified and directly assigning X from the OR operation

    // Instead of instantiating a missing module, directly use the OR logic
    // Removed the sky130_fd_sc_ms__or4b instantiation as it is unknown

endmodule