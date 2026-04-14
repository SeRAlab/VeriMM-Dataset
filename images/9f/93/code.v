module top_module(
    input clk,
    input reset,
    input pause,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the counter to 4'b0000
            q <= 4'b0000;
        end else if (!pause) begin
            // Counter increment: Increment by 1 when not paused
            q <= q + 1;
        end
    end

endmodule