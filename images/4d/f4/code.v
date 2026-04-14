module top_module(
    input clk,
    input reset_n,
    output reg [6:0] q
);

    always @(posedge clk) begin
        if (!reset_n) begin
            q <= 7'b0000000;  // Synchronous reset to zero
        end else begin
            q <= (q >> 1) ^ q;  // Gray code increment
        end
    end

endmodule