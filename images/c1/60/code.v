module dc2 (d, a, q);
   input d;			
   input a;			
   output q;			
   wire [2:0] m;		
   nand U1 (m[0], a, d);
   nand U2 (m[1], d, q);
   nand U3 (m[2], a, q);
   assign q = ~&m;
endmodule