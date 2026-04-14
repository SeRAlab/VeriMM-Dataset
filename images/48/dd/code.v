module top_module(
    input clk,
    input reset,
    input up,
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 3'b000;  // Synchronous reset to zero
        end else if (up) begin
            q <= q + 1;  // Count up
        end else begin
            q <= q - 1;  // Count down
        end
    end

endmodule