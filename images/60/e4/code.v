module top_module(clk, mem_write, address, write_data, read_data);input wire clk;
	input wire mem_write;
	input wire [31:0] address,write_data;
	output wire [31:0] read_data;
	
	
	reg [31:0] RAM [1023:0];
	
	
	assign read_data = RAM[address[31:2]];
	
	
	always@(posedge clk)
	begin
		if(mem_write)
			RAM[address[31:2]] <= write_data;
			
	end
endmodule