module t_ff_module(
    input t,
    input clk,
    output reg q
);

always @(posedge clk) begin
    if (t)
        q <= ~q;
end

endmodule

module top_t_ff_module(
    input t,
    input clk,
    output q
);

t_ff_module u_t_ff_module (
    .t(t),
    .clk(clk),
    .q(q)
);

endmodule