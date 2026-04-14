module top_module(funct,ALUOp,ALU_control_signal);input [5:0] funct;
	input [1:0] ALUOp;
	output reg [3:0] ALU_control_signal;
	
	
	always@(funct or ALUOp)
	begin
	casex({funct,ALUOp})
		{6'bxxxxxx,2'b00} : ALU_control_signal<=4'b0010; 
		{6'bxxxxxx,2'b01} : ALU_control_signal<=4'b0110; 
		{6'b100000,2'b10} : ALU_control_signal<=4'b0010; 
		{6'b100010,2'b10} : ALU_control_signal<=4'b0110; 
		{6'b100100,2'b10} : ALU_control_signal<=4'b0000; 
		{6'b100101,2'b10} : ALU_control_signal<=4'b0001; 
		{6'b101010,2'b10} : ALU_control_signal<=4'b0111; 
		default : ALU_control_signal<=4'bxxxx;
	endcase
	end

endmodule