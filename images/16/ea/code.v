module phase_detector (
    input clk_a,
    input clk_b,
    output phase_out
);
    assign phase_out = (clk_a == clk_b) ? 1'b1 : 1'b0;
endmodule