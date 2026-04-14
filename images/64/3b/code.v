module top_module(
    input clk,
    input reset,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b1111;  // Reset the counter to all ones
        end else begin
            q <= q - 1;  // Decrement the counter
        end
    end

endmodule