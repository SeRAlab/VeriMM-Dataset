module top_module(s0,s1,I,en,d0,d1,d2,d3);input s0,s1,I,en;

output d0,d1,d2,d3;

assign d0=(~s0)&(~s1)& I& en;
assign d1=(~s0)& s1& I& en;
assign d2=s0&(~s1)& I & en;
assign d3=s0& s1 & I & en;endmodule