module counter_4bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low asynchronous reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input en,           // Enable signal to increment the counter.

    output [3:0] count  // 4-bit counter output.
);

reg [3:0] count_r;

//------------------------------------------------
// Counter logic
always @(posedge clk or negedge rst_n)
    if (!rst_n) count_r <= 4'd0; // Asynchronous reset
    else if (en) count_r <= count_r + 1'b1; // Increment counter if enable is active

assign count = count_r;

endmodule