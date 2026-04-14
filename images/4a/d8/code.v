module t_flip_flop(
    input t,
    input clk,
    output reg q
);

    always @(posedge clk) begin
        if (t)
            q <= ~q;
    end

endmodule