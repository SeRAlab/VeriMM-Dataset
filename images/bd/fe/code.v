module up_counter_3bit(
    input clk,              // Chip clock signal.
    input rst_n,            // Active-low reset signal.
    input en,               // Enable signal to allow counting.
    input ld,               // Load signal.
    input [2:0] load_value, // 3-bit value to be loaded into the counter.

    output [2:0] count      // 3-bit counter output signal.
);

reg [2:0] count_r;

always @(posedge clk or negedge rst_n)
    if (!rst_n)
        count_r <= 3'b000; // Reset the counter to 0
    else if (ld)
        count_r <= load_value; // Load specified value into the counter
    else if (en)
        count_r <= count_r + 1'b1; // Increment counter

assign count = count_r;

endmodule