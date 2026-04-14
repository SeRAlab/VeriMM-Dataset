module pll_2x (
    input wire clk_in,   // Input clock
    input wire reset,    // Asynchronous reset
    output reg clk_out   // Doubled frequency clock output
);
    reg [1:0] clk_div; // 2-bit counter for clock division

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            clk_div <= 2'b00;
            clk_out <= 1'b0;
        end else begin
            clk_div <= clk_div + 1;
            if (clk_div == 2'b01) begin
                clk_out <= ~clk_out;
            end
        end
    end
endmodule