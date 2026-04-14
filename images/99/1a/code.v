module top_module(
    input clk,
    input reset,
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset: Reset the counter to zero
            q <= 3'b000;
        end else begin
            // Gray code counter: Generate next Gray code
            q <= q + 1;
            q <= q ^ (q >> 1);
        end
    end

endmodule