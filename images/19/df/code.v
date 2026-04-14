module pll_2x (
    input clk_in,
    input reset,
    output reg clk_out
);
    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            clk_out <= 1'b0;
        end else begin
            clk_out <= ~clk_out; // Toggle clock out
        end
    end
endmodule