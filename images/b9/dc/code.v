module top_module(clk_i, rst_i,IFID_write,address_i, instr_i, address_o, instr_o);input clk_i ;
	input rst_i;
	input IFID_write;
	input [31:0] address_i;
	input [31:0] instr_i;
	output reg [31:0] address_o;
	output reg [31:0] instr_o;

	always@(posedge clk_i)
	begin
		if (!rst_i)
		begin
			address_o <= 0;
			instr_o <= 0;
		end
		else if(IFID_write)begin
				address_o <= address_i;
				instr_o <= instr_i;
		end
	end

endmodule