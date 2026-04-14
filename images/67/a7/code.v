module top_module(
	input clk,
    output reg[7:0] d_ram, 
    input [7:0] dir_ram, 
    input [7:0] dir,	
    input leer_ram
     
    );always @(leer_ram,d_ram,dir,dir_ram) begin

		if(leer_ram==1'b1) d_ram<=dir; 
		else d_ram<=dir_ram ; 
		
		end
endmodule