module clock_gating(
    input clk,        // Clock input
    input enable,     // Enable signal
    output gated_clk  // Gated clock output
);
    assign gated_clk = enable ? clk : 1'b0; // If enable is high, output clk, else output 0
endmodule