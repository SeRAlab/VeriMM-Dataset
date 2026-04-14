module up_counter_32bit(
    input clk,           // Clock signal.
    input rst,           // Asynchronous reset signal.
    input en,            // Enable signal to increment the counter.

    output [31:0] count  // 32-bit counter output.
);

reg [31:0] count_r; // Counter register.

// Data bit control
always @(posedge clk or posedge rst)
    if (rst) count_r <= 32'b0; // Reset condition
    else if (en) count_r <= count_r + 1; // Increment when enabled

assign count = count_r;

endmodule