module d_flip_flop
(
    input clk,
    input reset,
    input enable,
    input d,
    output reg q
);
    always @(posedge clk) begin
        if (reset) begin
            q <= 1'b0; // Reset q to 0
        end else if (enable) begin
            q <= d; // Follow input d
        end
    end

endmodule