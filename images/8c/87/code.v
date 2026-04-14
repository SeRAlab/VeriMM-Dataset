module top_module(
    input clk,
    input reset,
    input up,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0000;  // Synchronous reset to the initial state
        end else if (up) begin
            q <= q + 1;  // Increment the counter
        end else begin
            q <= q - 1;  // Decrement the counter
        end
    end

endmodule