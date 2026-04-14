module pll_4x (
    input wire clk_in,
    input wire reset,
    output reg clk_out
);
    reg [1:0] clk_div; // 2-bit counter for division

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            clk_out <= 0;
            clk_div <= 0;
        end else begin
            clk_div <= clk_div + 1;
            if (clk_div == 3) begin
                clk_out <= ~clk_out; // Toggle output clock every 4 input clock cycles
                clk_div <= 0; // Reset counter
            end
        end
    end
endmodule