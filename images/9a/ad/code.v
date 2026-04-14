module binary_counter_4bit(
    input clk,    // Clock signal.
    input rst,    // Synchronous reset signal.
    input en,     // Enable signal.

    output [3:0] count // 4-bit count value.
);

reg [3:0] count_r; // Counter register.

//------------------------------------------------
// Counter operation
always @(posedge clk) begin
    if (rst) begin
        count_r <= 4'b0000; // Reset counter to 0
    end
    else if (en) begin
        if (count_r == 4'b1111) begin
            count_r <= 4'b0000; // Wrap around to 0 after reaching 15
        end
        else begin
            count_r <= count_r + 1; // Increment counter
        end
    end
end

assign count = count_r;

endmodule