module top_module(
    input clk,
    input reset,
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the counter to 3'b111
            q <= 3'b111;
        end else begin
            // Binary down-counter: Decrement the counter
            q <= q - 1;
        end
    end

endmodule