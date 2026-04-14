module up_down_counter(
    input clk,
    input reset,
    input up,
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the counter to zero
            q <= 3'b000;
        end else if (up) begin
            // Count up
            q <= q + 1;
        end else begin
            // Count down
            q <= q - 1;
        end
    end

endmodule