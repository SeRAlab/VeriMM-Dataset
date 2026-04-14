module d_flip_flop_with_reset (
    input clk,
    input reset,
    input d,
    output reg q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 1'b0;
        end else begin
            q <= d;
        end
    end

endmodule