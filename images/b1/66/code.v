module down_counter_4bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal.
    input en,           // Enable signal to allow counting.
    input load,         // Load signal to load the counter value.
    input [3:0] load_val, // 4-bit input value to be loaded into the counter.
    
    output [3:0] count  // 4-bit count value.
);

reg [3:0] count_r;

//------------------------------------------------
// Counter logic
always @(posedge clk or negedge rst_n)
    if (!rst_n) count_r <= 4'd0;  // Reset counter
    else if (load) count_r <= load_val; // Load counter
    else if (en) begin
        if (count_r == 4'd0) count_r <= 4'd15; // Wrap around
        else count_r <= count_r - 1'b1;        // Decrement counter
    end

assign count = count_r;

endmodule