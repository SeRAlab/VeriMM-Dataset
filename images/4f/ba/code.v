module top_module(
	input [31:0] pc,
	output reg [31:0] sal
);always@*
	begin
		sal=pc+4;	
	end

endmodule