module top_module( aluSrc1, aluSrc2, ALU_operation_i, result, zero, overflow );input	[32-1:0] aluSrc1;
input	[32-1:0] aluSrc2;
input	 [4-1:0] ALU_operation_i;

output	[32-1:0] result;
output			 zero;
output			 overflow;


wire			 zero;
wire			 overflow;
wire	[32-1:0] result;



reg [32-1:0] res;
wire signed [32-1:0] signedSrc1=aluSrc1, signedSrc2=aluSrc2;
always @(*) begin
	case (ALU_operation_i)
		0: res = aluSrc1 + aluSrc2;
		1: res = aluSrc1 - aluSrc2;
		2: res = aluSrc1 & aluSrc2;
		3: res = aluSrc1 | aluSrc2;
		4: res = ~(aluSrc1 | aluSrc2);
		5: res = (signedSrc1 < signedSrc2) ? 1:0;
		8: res = aluSrc1 + aluSrc2;
		9: res = aluSrc2 << aluSrc1;
		10: res = aluSrc2 >> aluSrc1;
		11: res = aluSrc1 - aluSrc2; 
		12: res = (signedSrc1 >= 0); 
		default: res = 0;
	endcase
end

assign result = res;
assign zero = (result == 0);
assign overflow = 0;


endmodule