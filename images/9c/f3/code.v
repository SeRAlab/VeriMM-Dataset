module top_module(out, a, b, c, d, e, f, g, h, sel);parameter n = 1;
   
   output [n-1:0] out;
   input [n-1:0]  a, b, c, d, e, f, g, h;
   input [2:0]    sel;

   assign         out = sel == 3'b000 ? a : 
                        sel == 3'b001 ? b :
                        sel == 3'b010 ? c : 
                        sel == 3'b011 ? d :
                        sel == 3'b100 ? e :
                        sel == 3'b101 ? f :
                        sel == 3'b110 ? g :
                        sel == 3'b111 ? h : 0 ;endmodule