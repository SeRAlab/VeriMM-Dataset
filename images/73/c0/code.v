module d_ff_module(
    input d,
    input clk,
    output reg q
);

always @(posedge clk) begin
    q <= d;
end

endmodule

module top_d_ff_module(
    input d,
    input clk,
    output q
);

d_ff_module u_d_ff_module (
    .d(d),
    .clk(clk),
    .q(q)
);

endmodule