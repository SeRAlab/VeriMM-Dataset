module top_module(input clk, reset, freeze, flush,  input [31 : 0] PC_in, Instruction_in, output reg [31 : 0] PC, Instruction);always@(posedge clk or posedge reset)
	begin
		if(reset)
		begin
			PC <= 32'b0;
			Instruction <= 32'b0;
		end
		else if (flush)
		  begin
		    Instruction <=32'b0 ;
		    end
		else if(!freeze) 
		begin
			Instruction <= Instruction_in;
			PC <= PC_in;
		end
	end
endmodule