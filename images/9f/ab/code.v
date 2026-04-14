module top_module(IF_ID_Hold, clock,reset,instruction,instructionPropagation, opA, opB);input IF_ID_Hold, clock, reset;
	input [19:0] instruction;
	
	output reg [19:0] instructionPropagation;
	output reg [3:0] opA, opB;

	always @(posedge clock)
	begin
		if (reset) begin
			
		end else begin

			if(IF_ID_Hold)
			begin
				instructionPropagation <= instructionPropagation;
				opA <= opA;
				opB <= opB;
			end
				
			else
			begin
				instructionPropagation <= instruction;
				opA <= instruction[11:8];
				opB <= instruction[7:4];
			end
			
		end
	end
endmodule