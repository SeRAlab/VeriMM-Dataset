module down_counter_4bit(
    input clk,           // Clock signal.
    input rst,           // Synchronous reset signal.
    input en,            // Enable signal to decrement the counter.

    output [3:0] count  // 4-bit counter output.
);

reg [3:0] count_r; // Counter register.

// Data bit control
always @(posedge clk)
    if (rst) count_r <= 4'b1111; // Reset condition
    else if (en) count_r <= count_r - 1; // Decrement when enabled

assign count = count_r;

endmodule