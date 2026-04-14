module frequency_divider (
    input clk,      // Input clock
    input reset,    // Active high reset
    output reg out_clk // Output divided clock
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            out_clk <= 0; // On reset, output clock is 0
        end else begin
            out_clk <= ~out_clk; // Toggle output clock
        end
    end
endmodule