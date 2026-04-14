module top_module(clk,addr,data,cs,we,oe);input clk;
	input [14:0] addr;
	inout [7:0] data;
	input cs;
	input we;
	input oe;

	reg [7:0] tmp_data;
	reg [7:0] mem[0:(1<<14)-1];

	always @ (posedge clk) begin	
		if(cs & we)
			mem[addr]<=data;
		if(cs & !we)
			tmp_data<=mem[addr];
	end
	

	assign data = cs & oe & !we ? mem[addr] : 8'hz;
endmodule