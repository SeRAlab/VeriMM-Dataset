module top_module(
    input clk,
    input reset_n,
    input enable,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (!reset_n) begin
            // Synchronous reset: Reset the counter to 8'b00000000
            q <= 8'b00000000;
        end else if (enable) begin
            // Counter increment: Increment by 1 when enabled
            q <= q + 1;
        end
    end

endmodule