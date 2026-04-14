module jk_flip_flop (
    input clk,
    input j,
    input k,
    output reg q
);

    always @(posedge clk) begin
        if (j && k)
            q <= ~q;
        else if (j)
            q <= 1;
        else if (k)
            q <= 0;
    end

endmodule