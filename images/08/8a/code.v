module clock_gating(
    input wire clk,
    input wire enable,
    output wire gated_clk
);
    assign gated_clk = enable ? clk : 1'b0;
endmodule