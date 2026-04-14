module pll_4x (
    input wire clk_in,
    input wire reset,
    output reg clk_out
);
    reg [1:0] clk_div; // 2-bit counter to divide the clock

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            clk_div <= 2'b00;
            clk_out <= 0;
        end else begin
            clk_div <= clk_div + 1;
            if (clk_div == 2'b11) begin
                clk_out <= ~clk_out; // Toggle output every 4 input clock cycles
            end
        end
    end
endmodule