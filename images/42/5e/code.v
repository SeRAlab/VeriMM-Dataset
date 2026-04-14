module top_module(
    input clk,
    input reset_n,
    input count_enable,
    output reg [3:0] q
);

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            // Asynchronous reset: Reset the counter to 4'b0000
            q <= 4'b0000;
        end else if (count_enable) begin
            // Increment the counter if count_enable is high
            q <= q + 1;
        end
    end

endmodule