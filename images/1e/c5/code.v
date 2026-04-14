module pll_2x (
    input wire clk_in,
    input wire reset,
    output reg clk_out
);

reg toggle;

always @(posedge clk_in or posedge reset) begin
    if (reset) begin
        clk_out <= 0;
        toggle <= 0;
    end else begin
        toggle <= ~toggle;
        clk_out <= toggle;
    end
end

endmodule