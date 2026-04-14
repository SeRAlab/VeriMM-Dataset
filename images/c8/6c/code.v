module simple_calc(A, B, op, C);
	input [7:0] A;
	input [7:0] B;
	input [1:0] op;
	output reg [7:0] C;
	
	always @(*)
	begin
		case(op)
			2'b00: C = A + B;
			2'b01: C = A - B;
			2'b10: C = A * B;
			2'b11: C = A / B;
		endcase
	end
endmodule