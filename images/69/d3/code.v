module counter_3bit(
    input clk,            // Chip clock signal.
    input rst,            // Reset signal.
    input en,             // Enable signal.
    input up_down,        // Control signal for increment/decrement.
    output reg [2:0] count // 3-bit output count.
);

always @(posedge clk or posedge rst) begin
    if (rst)
        count <= 3'b0;       // Reset counter to zero.
    else if (en) begin
        if (up_down)
            count <= count + 1; // Increment counter.
        else
            count <= count - 1; // Decrement counter.
    end
end

endmodule