module top_module(
    GCLK,
    SCE,
    GATE,
    CLK,
    VPWR,
    VGND,
    VPB,
    VNB
);// Module ports
    output GCLK;
    input SCE;
    input GATE;
    input CLK;
    input VPWR;
    input VGND;
    input VPB;
    input VNB;

    // Local signals
    reg m0;
    wire m0n;
    wire SCE_GATE;
    wire GCLK_b;

    // Negate the input clock signal
    assign m0n = ~CLK;

    // Latch the negated clock signal with the gate and clear enable signals
    always @(posedge CLK or negedge SCE) begin
        if (!SCE)
            m0 <= 1'b0; // Clear state if SCE is low
        else if (GATE)
            m0 <= m0n; // Latch the negated clock
    end

    // Combine the SCE and GATE signals
    assign SCE_GATE = ~(SCE | GATE);

    // Combine the negated clock signal and the original clock signal
    assign GCLK_b = m0n & CLK;

    // Generate the gated clock signal
    assign GCLK = (GCLK_b & SCE_GATE) ? GCLK_b : 1'b0; // Ensuring output respects SCE_GATE state

endmodule