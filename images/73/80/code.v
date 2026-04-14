module top_module(I0, I1, O, SEL);parameter 	     WIDTH=32;

   
   
   
   
   

   
   input [WIDTH-1:0] I0;
   
   input [WIDTH-1:0] I1;
   
   output [WIDTH-1:0] O;
   
   input 	      SEL;

   
   
   
   
   
   
   assign 	      O = SEL ? I1 : I0;endmodule