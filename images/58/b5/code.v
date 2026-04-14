module top_module(i_clk, i_rst_n, i_pc, o_pc);input               i_clk, i_rst_n;
input       [31:0]  i_pc;
output  reg [31:0]  o_pc;


	always@(posedge i_clk or negedge i_rst_n)
		begin
			if(!i_rst_n) 
			o_pc <= 0; 
			else
			o_pc <= i_pc;
		end
endmodule