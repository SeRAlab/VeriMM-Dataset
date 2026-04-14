module top_module(
    input clk,
    input reset,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the counter to 4'b0000
            q <= 4'b0000;
        end else begin
            // Binary up-counter: Increment the counter
            q <= q + 1;
        end
    end

endmodule