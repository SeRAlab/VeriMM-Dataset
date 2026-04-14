module top_module(
    x0,
    x1,
    s,
    y
);input x0;
input x1;
input s;
output y;
wire y;





assign y = (((!s) && x0) | (s && x1));

endmodule