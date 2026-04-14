module pll_8x (
    input wire clk_in,       // Input clock
    input wire reset,        // Reset signal
    output reg clk_out       // Output clock (8x)
);

reg [2:0] counter;           // 3-bit counter for 8x frequency
parameter DIVISOR = 8;       // Divisor to achieve 8x frequency

always @(posedge clk_in or posedge reset) begin
    if (reset) begin
        counter <= 3'b0;
        clk_out <= 1'b0;     // Reset output clock
    end else begin
        counter <= counter + 1;
        if (counter == DIVISOR - 1) begin
            clk_out <= ~clk_out; // Toggle output clock
            counter <= 3'b0; // Reset counter
        end
    end
end

endmodule