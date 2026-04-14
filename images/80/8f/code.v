module top_module(
    Q,
    RESET_B,
    D,
    GATE,
    VPWR,
    VGND,
    VPB,
    VNB
);output reg Q; // Changed to reg to hold state
    input RESET_B;
    input D;
    input GATE;
    input VPWR;
    input VGND;
    input VPB;
    input VNB;

    wire reset;
    wire enable;

    assign reset = ~RESET_B;
    assign enable = GATE;

    // Instantiate the correct flip-flop model here
    // Note: Replace `sky130_fd_sc_ls__dlrtp` with the actual module name that should be instantiated
    // Ensure the module is defined in your library path; if not, include it
    /* sky130_fd_sc_ls__dlrtp base (
        .Q(Q),
        .RESET_B(reset),
        .D(D),
        .GATE(enable),
        .VPWR(VPWR),
        .VGND(VGND),
        .VPB(VPB),
        .VNB(VNB)
    ); */

    always @(posedge GATE or posedge reset) begin
        if (reset) 
            Q <= 1'b0; // Reset Q to 0
        else 
            Q <= D; // Capture D on GATE rising edge
    end

endmodule