module t_flip_flop (
    input clk,
    input t_enable,
    output reg q
);

    always @(posedge clk) begin
        if (t_enable)
            q <= ~q;
    end

endmodule