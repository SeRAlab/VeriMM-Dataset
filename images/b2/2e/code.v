module top_module(
    input clk,
    input reset,
    input up,
    input down,
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 3'b000;  // Reset the counter to 0
        end else if (up && ~down) begin
            q <= q + 1;  // Increment the counter if up is high and down is low
        end else if (~up && down) begin
            q <= q - 1;  // Decrement the counter if down is high and up is low
        end
    end

endmodule