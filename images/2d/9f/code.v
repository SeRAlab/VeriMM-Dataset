module Fractional_N_PLL (
    input wire clk_in,       // Input clock
    input wire reset,        // Reset signal
    input wire enable,       // Enable signal
    input wire [7:0] frac,   // Fractional input
    output reg clk_out       // Output clock
);
    reg [15:0] counter;       // Counter for frequency division
    reg [15:0] target_count;  // Target count for the output frequency
    reg [7:0] fractional_part; // Stores the fractional part for division
    integer i;
    
    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_out <= 0;
            target_count <= 16'hFFFF; // Default target
        end else if (enable) begin
            fractional_part <= frac;
            target_count <= (16'hFFFF * fractional_part) / 256; // Example of a fractional division
            if (counter >= target_count) begin
                clk_out <= ~clk_out; // Toggle output clock
                counter <= 0; // Reset counter
            end else begin
                counter <= counter + 1; // Increment counter
            end
        end
    end
endmodule