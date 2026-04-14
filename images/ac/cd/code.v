module top_module(
    input clk,
    input reset_n,
    input up_down,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (!reset_n) begin
            // Synchronous reset: Reset the counter to 4'b0000
            q <= 4'b0000;
        end else if (up_down) begin
            // Counter increment: Increment by 1 when up_down is high
            q <= q + 1;
        end else begin
            // Counter decrement: Decrement by 1 when up_down is low
            q <= q - 1;
        end
    end

endmodule