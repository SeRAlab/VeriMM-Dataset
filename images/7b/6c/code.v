module bin_counter_4bit(
    input clk,      // Chip clock signal.
    input rst,      // Synchronous reset signal. Defined as 1 to reset the counter.
    input en,       // Enable signal.

    output reg [3:0] count // 4-bit output of the counter.
);

always @(posedge clk) begin
    if (rst) 
        count <= 4'h0; // Reset counter to 0
    else if (en) 
        count <= count + 1; // Increment counter
end

endmodule