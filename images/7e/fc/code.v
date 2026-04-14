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

wire x0x1_yWire;
wire MUX2_1_Combo1_0_y;




assign x0x1_yWire = (((!s0) && x0) | (s0 && x1));



assign MUX2_1_Combo1_0_y = (((!s0) && x2) | (s0 && x3));



assign y = (((!s1) && x0x1_yWire) | (s1 && MUX2_1_Combo1_0_y));

endmodule