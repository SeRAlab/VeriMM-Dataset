module top_module(
    x0,
    x1,
    x2,
    x3,
    s0,
    s1,
    y
);input x0;
input x1;
input x2;
input x3;
input s0;
input s1;
output y;
wire y;





assign y = (((!s0) && (!s1) && x0) || (s0 && (!s1) && x1) || ((!s0) && s1 && x2) || (s0 && s1 && x3));

endmodule