module top_module(
    x,
    s,
    y0,
    y1
);input x;
input s;
output y0;
wire y0;
output y1;
wire y1;





assign y0 = ((!s) && x);
assign y1 = (s && x);

endmodule