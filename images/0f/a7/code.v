module PLL_8x (
    input wire clk_in,          // Input clock
    input wire reset,           // Reset signal
    output reg clk_out          // Output clock
);
    reg [2:0] counter;          // 3-bit counter for division

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 3'b000;
            clk_out <= 0;
        end else begin
            if (counter == 3'b111) begin
                clk_out <= ~clk_out; // Toggle output clock every 8 input clock cycles
                counter <= 3'b000;    // Reset counter
            end else begin
                counter <= counter + 1; // Increment counter
            end
        end
    end
endmodule