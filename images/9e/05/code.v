module top_module(
	input	clk,
	input	reset,		
	input is_branch, 	
	input [31:0] newPC, 
	output reg [31:0] PC
);wire [31:0] PC_wire;

	assign PC_wire = ( is_branch == 1 ) ?  newPC : (PC + 4);

	always@(posedge clk) 
	begin
		if(!reset)
			PC <= PC_wire;
		else
			
			PC  <= 0;
	end
endmodule