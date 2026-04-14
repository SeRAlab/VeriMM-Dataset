module top_module(
	input rst,
	input [3:0]ALUcontrol,
	input [31:0]alu_a,
	input [31:0]alu_b,
	output zero,
	output reg[31:0]alu_out
);always@(*)
 begin
	case(ALUcontrol)
		4'b0000: alu_out<=alu_a+alu_b;      
		4'b0001: alu_out<=alu_a-alu_b;      
		4'b0010: alu_out<=alu_a&alu_b;      
		4'b0011: alu_out<=alu_a|alu_b;      
		4'b0100: alu_out<=alu_a^alu_b;      
		4'b0101: alu_out<=~(alu_a|alu_b);   
		4'b0110: if(alu_a<alu_b) alu_out<=1; else alu_out<=0;
		default: alu_out<=alu_out;
	endcase
end
assign zero=(alu_out)?0:1;endmodule