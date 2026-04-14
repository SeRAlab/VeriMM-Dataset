module top_module(s0,s1,x,y);output s0,s1;
input x,y;

wire t1,t2,t3;

nand n1(t1,x,y);
nand n2(t2,x,t1);
nand n3(t3,t1,y);

assign s0 = ~(t2 & t3);

assign s1 = (x & y);endmodule