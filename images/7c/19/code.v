module up_down_counter_enable
(
    input clk,
    input reset,
    input enable,
    input up_down,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0000; // Clear counter to 0000
        end else if (enable) begin
            if (up_down) begin
                q <= q + 1; // Increment counter
            end else begin
                q <= q - 1; // Decrement counter
            end
        end
    end

endmodule