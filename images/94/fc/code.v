module binary_counter_4bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input en,           // Enable signal to allow counting.

    output [3:0] count  // 4-bit counter output signal.
);

reg [3:0] count_r;

always @(posedge clk or negedge rst_n)
    if (!rst_n) 
        count_r <= 4'b0000; // Reset the counter to 0
    else if (en)
        if (count_r == 4'b1111)
            count_r <= 4'b0000; // Roll over to 0
        else
            count_r <= count_r + 1'b1; // Increment counter

assign count = count_r;

endmodule