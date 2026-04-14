module top_module(
	A, 
	OE, 
	Y);input [1:0] A;
   input OE;
   output [3:0] Y;
   
   assign Y = OE ? {A, ~A} : 4'b0;
endmodule