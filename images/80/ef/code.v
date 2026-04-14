module t_flip_flop (
    input clk,
    input toggle,
    input reset,
    output reg q
);

    always @(posedge clk) begin
        if (reset)
            q <= 1'b0;
        else if (toggle)
            q <= ~q;
    end

endmodule