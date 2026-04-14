module top_module(in, shift, out);input  [7:0] in;
input  [2:0] shift;
output [7:0] out;


	assign out=(shift == 3'b000)? in :
			   (shift == 3'b001)? in<<1 :
			   (shift == 3'b010)? in<<2 :
			   (shift == 3'b011)? in<<3 :
			   (shift == 3'b100)? in<<4 :
			   (shift == 3'b101)? in<<5 :
			   (shift == 3'b110)? in<<6 : in<<7;



endmodule