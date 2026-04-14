module top_module(input [3:0] a,input [3:0] b,input Cin,output [3:0] y,output Cout);wire [3:0] g, p, c; 
 assign g = a & b; 
 assign p = a | b; 
 assign c[0] = Cin; 
 assign c[1] = g[0] | (Cin & p[0]); 
 assign c[2] = g[1] | (g[0] & p[1]) | (Cin & p[0] & p[1]); 
 assign c[3] = g[2] | (g[1] & p[2]) | (g[0] & p[1] & p[2]) | (Cin & p[0] & p[1] & p[2]); 
 assign Cout = g[3] | (g[2] & p[3]) | (g[1] & p[2] & p[3]) | (g[0] & p[1] & p[2] & p[3]) | (Cin & p[0] & p[1] & p[2] & p[3]); 
 assign y = a ^ b ^ c; 
 endmodule