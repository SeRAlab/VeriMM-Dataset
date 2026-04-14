module t_flip_flop (
    input clk,
    input toggle_enable,
    output reg q );always @(posedge clk) begin
    if (toggle_enable)
        q <= ~q;
end

endmodule