module top_module(
    input clk,
    input reset,
    input enable,
    output reg [11:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the counter to 12'b000000000000
            q <= 12'b000000000000;
        end else if (enable) begin
            // Counter increment: Increment by 1 when enabled
            q <= q + 1;
        end
    end

endmodule