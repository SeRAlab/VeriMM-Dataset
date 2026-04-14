module binary_counter_4bit(
    input clk,          // Chip clock signal.
    input rst,          // Active-high reset signal. Defined as 1 for chip reset; defined as 0 for reset signal inactive.
    input en,           // Enable signal for the counter.

    output [3:0] count  // 4-bit count value.
);

reg [3:0] count_r; // Register to hold the count value.

// Counter logic
always @(posedge clk) begin
    if (rst)
        count_r <= 4'b0000; // Reset counter
    else if (en)
        count_r <= count_r + 1'b1; // Increment counter
end

assign count = count_r;

endmodule