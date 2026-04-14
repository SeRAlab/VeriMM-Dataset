module top_module(
    input inclk,
    input ena,
    output outclk
);// Simple pass-through logic when enabled
    assign outclk = ena ? inclk : 1'b0; // Outputs inclk if ena is high; otherwise, outputs 0.
endmodule