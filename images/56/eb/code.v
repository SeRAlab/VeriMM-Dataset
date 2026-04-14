module top_module(c_in, c_out, c, p, g, P, G);input [3:0] p, g;
   input c_in;
   
   output [2:0] c;
   output c_out;
   output P, G;
   
   assign  c[0] = g[0] | (p[0] & c_in); 
   assign  c[1] = g[1] | (g[0] & p[1]) | (p[1] & p[0] & c_in); 
   assign  c[2] = g[2] | (g[1] & p[2]) | (g[0] & p[1] & p[2]) | (p[2] & p[1] & p[0] & c_in); 
   assign  c_out = g[3] | (g[2] & p[3]) | (g[1] & p[2] & p[3]) | (g[0] & p[1] & p[2] & p[3]) | (p[3] & p[2] & p[1] & p[0] & c_in);  
   
   assign  G = g[3] | (g[2] & p[3]) | (g[1] & p[2] & p[3]) | (p[3] & p[2] & p[1] & g[0]);
   assign  P = p[3] & p[2] & p[1] & p[0];
   
endmodule