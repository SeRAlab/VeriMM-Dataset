module top_module(
    x,
    y,
    v
);input signed [15:0] x;
input signed [15:0] y;
output signed [15:0] v;
wire signed [15:0] v;







assign v = ((x + y) * 10);

endmodule