module t_flip_flop(clk, rst, t, q);

    input clk;
    input rst;
    input t;
    output q;
    reg q;

    always @(posedge clk or posedge rst)
    begin
        if (rst)
            q <= 1'b0;
        else if (t)
            q <= ~q;
    end

endmodule