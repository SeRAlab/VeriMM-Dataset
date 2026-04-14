module top_module(
    input clk,
    input reset,
    input enable,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the counter to 4'b0000
            q <= 4'b0000;
        end else if (enable) begin
            // Increment the counter if enable is high
            q <= q + 1;
        end
    end

endmodule