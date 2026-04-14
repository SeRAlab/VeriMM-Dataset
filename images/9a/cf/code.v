module top_module(
    x1,
    x2,
    p,
    g
);input x1;
input x2;
output p;
wire p;
output g;
wire g;





assign p = (x1 ^ x2);
assign g = (x1 & x2);

endmodule