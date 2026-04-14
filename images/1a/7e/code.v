module pll_8x (
    input wire clk_in,
    input wire rst,
    output reg clk_out
);
    reg [2:0] phase_diff;
    reg [2:0] vco_count;
    parameter DIVIDER = 8;

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            vco_count <= 0;
            clk_out <= 0;
        end else begin
            phase_diff <= (phase_diff + 1) % DIVIDER;
            if (phase_diff == 0) begin
                clk_out <= ~clk_out;
            end
        end
    end
endmodule