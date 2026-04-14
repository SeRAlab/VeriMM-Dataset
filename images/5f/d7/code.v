module top_module(inputA, inputB, ALUop, result, zero);input [31:0] inputA, inputB;
input [2:0] ALUop; 

output [31:0] result;
reg [31:0] result;
output zero;
reg zero;


always @(inputA or inputB or ALUop)
begin 


	case(ALUop)
		3'b010:	result	=	inputA	+	inputB;
		3'b110:	result	=	inputA	-	inputB;
		3'b001:	result	=	inputA	|	inputB;
		3'b000:	result	=	inputA	&	inputB;
		3'b111:	
		begin
			if(inputA < inputB)
				result	=	1;
			else
				result	=	0;
		end
	endcase

	if (inputA == inputB)
			zero = 1;
	else
			zero = 0;
end 
endmodule