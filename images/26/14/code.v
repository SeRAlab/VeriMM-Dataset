module pll_4x (
    input wire clk_in,    // Input clock
    input wire enable,    // Enable signal
    input wire reset,     // Asynchronous reset
    output reg clk_out    // Output clock
);

    reg [1:0] counter; // 2-bit counter to divide by 4

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 2'b00; // Reset counter
            clk_out <= 0;     // Reset output
        end else if (enable) begin
            counter <= counter + 1;
            if (counter == 2'b11) begin
                clk_out <= ~clk_out; // Toggle output clock every 4 input clock cycles
            end
        end
    end

endmodule