module top_module(
	A0, 
	A1, 
	B0, 
	Y);input A0;
   input A1;
   input B0;
   output Y;

   wire nor_output;
   wire and_output;

   assign nor_output = ~(A0 | A1);
   assign and_output = nor_output & B0;
   assign Y = and_output;

endmodule