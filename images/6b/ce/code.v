module top_module(
    input clk,
    input reset,
    input [6:0] data,
    output reg parity
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the parity bit to 0
            parity <= 1'b0;
        end else begin
            // Generate even parity
            parity <= ^data;
        end
    end

endmodule