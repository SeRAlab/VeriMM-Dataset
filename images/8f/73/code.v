module top_module(
    input clk,
    input reset_n,
    input enable,
    output reg [15:0] q
);

    always @(posedge clk) begin
        if (!reset_n) begin
            // Synchronous reset: Reset the counter to 16'b1111111111111111
            q <= 16'b1111111111111111;
        end else if (enable) begin
            // Counter decrement: Decrement by 1 when enabled
            q <= q - 1;
        end
    end

endmodule