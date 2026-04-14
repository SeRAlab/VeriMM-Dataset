module top_module(
	A, 
	B, 
	C, 
	Y);input A;
   input B;
   input C;
   output Y;
   
   wire AB_nor;
   wire AB_nor_C_nor;
   
   nor(AB_nor, A, B);
   nor(AB_nor_C_nor, AB_nor, C);
   assign Y = AB_nor_C_nor;
   
endmodule