module top_module(A, B, ALU_operation, res, zero, overflow );input signed [31:0] A, B;
	input [2:0] ALU_operation;
	output [31:0] res;
	output zero, overflow ;
	wire [31:0] res_and, res_or, res_add, res_sub, res_nor, res_slt, res_xor, res_srl;
	reg [31:0] res;
	parameter one = 32'h00000001, zero_0 = 32'h00000000;

	assign res_and = A&B;
	assign res_or = A|B;
	assign res_add = A+B;
	assign res_sub = A-B;
	assign res_nor=~(A | B);
	assign res_slt =(A < B) ? one : zero_0;
	assign res_xor = A^B;
	assign res_srl = B>>1;

	always @*
	
		case (ALU_operation)
			3'b000: res=res_and;
			3'b001: res=res_or;
			3'b010: res=res_add;
			3'b110: res=res_sub;
			3'b100: res=res_nor;
			3'b111: res=res_slt;
			3'b011: res=res_xor;
			3'b101: res=res_srl;
			default: res=res_add;
		
		endcase
	assign zero = (res==0)? 1: 0;

endmodule