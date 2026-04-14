module binary_counter_async_reset
(
    input clk,
    input reset,
    output reg [3:0] q
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 4'b0000; // Clear counter to 0000
        end else begin
            q <= q + 1; // Increment counter
        end
    end

endmodule