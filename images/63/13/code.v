module top_module(p,g,cin,c);input [3:0] p,g;
input cin;
output [3:0] c;

assign c[0]=(g[0]|(p[0]&cin));
assign c[1]=(g[1]|(p[1]&g[0])|(p[1]&p[0]&cin));
assign c[2]=(g[2]|(p[2]&g[1])|(p[2]&p[1]&g[0])|(p[2]&p[1]&p[0]&cin));
assign c[3] = (g[3]|(p[3]&g[2])|(p[3]&p[2]&g[1])|(p[3]&p[2]&p[1]&p[0]&cin));endmodule