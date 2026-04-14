module top_module(a_bus,b_bus ,accumulator,zero_flag,opcode);input [2:0] opcode;
	input [15:0] a_bus,b_bus;
	output reg [15:0]accumulator;
	output zero_flag;
	
	parameter add=3'b000,sub=3'b001,mul=3'b010; 
	always@(*)begin
	case(opcode)
		add:begin
			accumulator=0;
			accumulator= a_bus + b_bus; 
		end
		sub:begin
			accumulator=0;
			accumulator= a_bus - b_bus; 
			end
		mul:accumulator= a_bus*b_bus; 
	endcase
	end
	assign zero_flag=(accumulator) ? 1'b0:1'b1;
	
endmodule