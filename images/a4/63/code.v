module counter_4bit(
    input clk,        // Clock signal
    input rst,        // Active-high synchronous reset signal
    output reg [3:0] q // 4-bit counter output
);

// Synchronous reset and counting logic
always @(posedge clk) begin
    if (rst)
        q <= 4'b0000; // Synchronous reset
    else
        q <= q + 1;   // Increment counter
end

endmodule