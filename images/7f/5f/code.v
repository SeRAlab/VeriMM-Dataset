module top_module(Address, Instruct);input [9:0] Address;
	output [31:0] Instruct;
	
	reg [31:0] temp;
	reg [31:0] instruct_memory[1023:0];
	
	always@(Address)
	begin
		temp = instruct_memory[Address];
	end
	
	assign Instruct = temp;
endmodule