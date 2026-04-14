module top_module(out, a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, sel);parameter z = 1;
   
   output [z-1:0] out;
   input [z-1:0]  a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p;
   input [3:0]    sel;

   assign         out = sel == 4'b0000 ? a : 
                        sel == 4'b0001 ? b :
                        sel == 4'b0010 ? c : 
                        sel == 4'b0011 ? d :
                        sel == 4'b0100 ? e :
                        sel == 4'b0101 ? f :
                        sel == 4'b0110 ? g :
                        sel == 4'b0111 ? h :
                        sel == 4'b1000 ? i :
                        sel == 4'b1001 ? j :
                        sel == 4'b1010 ? k :
                        sel == 4'b1011 ? l :
                        sel == 4'b1100 ? m :
                        sel == 4'b1101 ? n :
                        sel == 4'b1110 ? o :
                        sel == 4'b1111 ? p : 0 ;endmodule