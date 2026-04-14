module binary_counter_sync_async_reset
(
    input clk,
    input async_reset,
    input sync_reset,
    output reg [3:0] q
);

    always @(posedge clk or posedge async_reset) begin
        if (async_reset) begin
            q <= 4'b0000; // Asynchronous reset
        end else if (sync_reset) begin
            q <= 4'b0000; // Synchronous reset
        end else begin
            q <= q + 1; // Increment counter
        end
    end

endmodule