module top_module(
    input clk,
    input reset_n,
    output reg [3:0] q
);

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            q <= 4'b0000;  // Asynchronous reset to zero
        end else if (q == 4'b1001) begin
            q <= 4'b0000;  // Wrap around from 9 to 0
        end else begin
            q <= q + 1;  // Increment counter
        end
    end

endmodule