module PLL_4x (
    input wire clk_ref,   // Reference clock input
    input wire reset,     // Reset input
    input wire enable,    // Enable input
    output reg clk_out    // Output clock
);
    reg [1:0] counter;    // 2-bit counter to generate 4x output

    always @(posedge clk_ref or posedge reset) begin
        if (reset) begin
            counter <= 2'b00;
            clk_out <= 0;
        end else if (enable) begin
            counter <= counter + 1;
            if (counter == 2'b11) begin
                clk_out <= ~clk_out; // Toggle output clock every 4 reference clock cycles
                counter <= 2'b00;     // Reset counter
            end
        end
    end
endmodule