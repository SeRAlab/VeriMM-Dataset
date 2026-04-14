module t_flip_flop_async_reset (
    input clk,
    input reset,
    input t_enable,
    output reg q
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 0;
        else if (t_enable)
            q <= ~q;
    end

endmodule