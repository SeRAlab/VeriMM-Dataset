module up_down_counter_3bit(
    input clk,    // Chip clock signal.
    input rst,    // Active-high reset signal.
    input up,     // Up/Down control signal.
    
    output reg [2:0] count  // 3-bit output counter value.
);

//------------------------------------------------
// 3-bit up-down counter logic
always @(posedge clk)
    if (rst) count <= 3'b000;  // Reset counter
    else if (up) count <= count + 1;  // Increment counter
    else count <= count - 1;  // Decrement counter

endmodule