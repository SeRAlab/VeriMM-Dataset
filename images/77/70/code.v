module top_module(
    input clk,
    input reset_n,
    input enable,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (!reset_n) begin
            // Synchronous reset: Reset the counter to 4'b0000
            q <= 4'b0000;
        end else if (enable) begin
            // Counter increment: Increment by 3 when enabled
            q <= q + 3;
        end
    end

endmodule