module counter_4bit(
    input clk,       // Chip clock signal.
    input rst,       // Synchronous reset signal.
    input en,        // Enable signal.

    output reg [3:0] count // 4-bit output of the counter.
);

always @(posedge clk) begin
    if (rst)
        count <= 4'b0000; // Reset counter to 0
    else if (en)
        count <= count + 1; // Increment counter
end

endmodule