module pll_4x (
    input wire clk_in,
    input wire reset,
    input wire enable,
    output reg clk_out
);
    reg [1:0] counter; // 2-bit counter for dividing the input clock

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 2'b00;
            clk_out <= 0;
        end else if (enable) begin
            counter <= counter + 1;
            if (counter == 2'b11) begin
                clk_out <= ~clk_out; // Toggle output clock every 4 input clock cycles
            end
        end
    end
endmodule