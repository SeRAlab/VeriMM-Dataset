module top_module(
    input clk,
    input reset,
    input up,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the counter to 5'b00000
            q <= 5'b00000;
        end else begin
            // Up/down counter: Increment or decrement based on the 'up' signal
            if (up) begin
                q <= q + 1;
            end else begin
                q <= q - 1;
            end
        end
    end

endmodule