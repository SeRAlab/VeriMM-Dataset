module top_module(s1, p1, q1, r1);output s1;
input p1, q1, r1;
assign s= ~(p1 & q1 & r1);endmodule