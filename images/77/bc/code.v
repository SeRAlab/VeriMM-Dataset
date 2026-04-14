module top_module(arith_out, C, V, A, B, Opcode);output reg [3:0] arith_out;
output reg C,V;

input [3:0] A,B;
input [1:0] Opcode;


always @ (*)
begin
 case(Opcode[1:0])
	2'b00 : {C,arith_out} = A+B;
	2'b01 : {C,arith_out} = A+1;
	2'b10 : {C,arith_out} = A-B;
	2'b11 : {C,arith_out}= A-1;
	endcase

V  = (A[3:0]<B[3:0]) ? 1 : 0;


end

endmodule