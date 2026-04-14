module top_module(y,I0,I1,s0);output y;
input I0,I1,s0;
wire y;
not(s0b,s0);
assign y = (I0&s0)|(I1&s0b);endmodule