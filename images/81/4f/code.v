module top_module(
	input clock,
	input reset,
	input [31:0] PC_next,
	output[31:0] PC
);reg [31:0] regPC;
wire [31:0] PCnext;
assign PCnext = PC_next;
always@(posedge clock)
	begin
		if(reset)
		begin
			regPC <= 23'b10000000000000000000000;
		end
		else
		begin
			regPC <= PCnext;
		end

	end
assign PC = regPC;endmodule