module top_module(
    input CLK,
    input GATE,
    input VPB,
    input VPWR,
    input VGND,
    input VNB,
    output GCLK
);wire gated_clk;

    assign gated_clk = (GATE == 1'b1) ? CLK : 1'b0;
    assign GCLK = gated_clk;

endmodule