module top_module(out, A, B, op);input [3:0] A, B;
	input [2:0] op;
	output reg [3:0] out;
	always@ (op) 
	begin
	if(op == 3'b000) 
		out = A + B;
	else if(op == 3'b001)
		out = A-B;
	else if(op == 3'b010)
		out = A ^ B;
	else if(op == 3'b011)
		out = A | B;
	else if(op == 3'b100)
		out = A & B;
	else if(op == 3'b101)
		out = ~(A | B);
	else if(op == 3'b110)
		out = ~(A&B);
	else if(op == 3'b111)
		out = ~(A^B);
	end
endmodule