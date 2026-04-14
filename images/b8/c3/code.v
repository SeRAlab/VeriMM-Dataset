module top_module(
    GCLK,
    SCE,
    GATE,
    CLK
);// Module ports
    output GCLK;
    input  SCE;
    input  GATE;
    input  CLK;

    // Local signals
    wire m0;
    wire m0n;
    wire clkn;
    wire SCE_GATE;
    reg  latch; // D-latch implementation

    // Inverting CLK to create clkn
    not                   not1(clkn, CLK);
    
    // Generating SCE_GATE signal
    nor                   nor0(SCE_GATE, GATE, SCE);

    // D-latch implementation
    always @(posedge SCE_GATE or negedge clkn) begin
        if (!clkn)
            latch <= 0;          // Reset condition
        else
            latch <= m0;        // Capture data
    end

    // Output assignment
    assign m0 = latch;         // latch output to m0
    assign m0n = ~m0;          // m0 inverted
    and                    and0(GCLK, m0n, CLK);

endmodule