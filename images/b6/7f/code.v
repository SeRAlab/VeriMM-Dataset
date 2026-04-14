module t_flip_flop(
    input clk,
    input t,
    output reg q
);

    always @(posedge clk) begin
        if (t)
            q <= ~q;
    end

endmodule