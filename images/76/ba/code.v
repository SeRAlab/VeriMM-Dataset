module up_down_counter_16bit(
    input clk,           // Clock signal.
    input rst,           // Synchronous reset signal.
    input en,            // Enable signal to update the counter.
    input dir,           // Direction control signal.

    output [15:0] count  // 16-bit counter output.
);

reg [15:0] count_r; // Counter register.

// Data bit control
always @(posedge clk)
    if (rst) count_r <= 16'b0; // Reset condition
    else if (en)
        if (dir) count_r <= count_r + 1; // Increment when direction is 1
        else count_r <= count_r - 1; // Decrement when direction is 0

assign count = count_r;

endmodule