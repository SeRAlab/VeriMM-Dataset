module top_module(din, addr, write_en, clk, dout);parameter addr_width = 5;
	parameter data_width = 16;
	input [addr_width-1:0] addr;
	input [data_width-1:0] din;
	input write_en, clk;
	output [data_width-1:0] dout;

	reg [data_width-1:0] dout; 
	reg [data_width-1:0] mem [(1<<addr_width)-1:0];

	always @(posedge clk)
	begin
		if (write_en) mem[(addr)] <= din;
		dout = mem[addr]; 
	end
endmodule