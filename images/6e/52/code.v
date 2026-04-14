module top_module(
    input clk,
    input reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b11111;  // Synchronous reset to 31
        end else begin
            q <= q - 1;  // Count down
        end
    end

endmodule