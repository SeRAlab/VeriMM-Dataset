module top_module(
    x,
    s0,
    s1,
    y0,
    y1,
    y2,
    y3
);input x;
input s0;
input s1;
output y0;
wire y0;
output y1;
wire y1;
output y2;
wire y2;
output y3;
wire y3;

wire s0_y2y3_WIRE;
wire s0_y0y1_WIRE;




assign s0_y0y1_WIRE = ((!s1) && x);
assign s0_y2y3_WIRE = (s1 && x);



assign y0 = ((!s0) && s0_y0y1_WIRE);
assign y1 = (s0 && s0_y0y1_WIRE);



assign y2 = ((!s0) && s0_y2y3_WIRE);
assign y3 = (s0 && s0_y2y3_WIRE);

endmodule