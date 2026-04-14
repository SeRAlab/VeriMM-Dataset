module top_module(
	read_address_1, 
	read_address_2, 
	write_address, 
	write_data, 
	reg_write, 
	rst, 
	data_reg_1, 
	data_reg_2);input [4:0] read_address_1;
   input [4:0] read_address_2;
   input [4:0] write_address;
   input [31:0] write_data;
   input reg_write;
   input rst;
   output [31:0] data_reg_1;
   output [31:0] data_reg_2;

   
   wire N4144;

   assign N4144 = rst ;endmodule