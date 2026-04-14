module top_module(
    input [31:0] ALUSrcA,
    input [31:0] ALUSrcB,
    input [2:0] ALUop,
    output zero,
    output sign,
    output reg[31:0] result
    );always@( ALUop or ALUSrcA or ALUSrcB) begin
		case( ALUop )
			3'b000: result = ALUSrcA + ALUSrcB;
			3'b001: result = ALUSrcA - ALUSrcB;
			3'b100: result = ALUSrcB << ALUSrcA;
			3'b101: result = ALUSrcA | ALUSrcB;
			3'b110: result = ALUSrcA & ALUSrcB;
			3'b111: result = ALUSrcA ^ ALUSrcB; 
			3'b011: result = (ALUSrcA < ALUSrcB) ? 1 : 0;
            3'b010: begin 
                if (ALUSrcA < ALUSrcB &&((ALUSrcA[31] == 0 && ALUSrcB[31]==0) || (ALUSrcA[31] == 1 && ALUSrcB[31]==1))) result = 1;
                else if (ALUSrcA[31] == 0 && ALUSrcB[31]==1)  result = 0;
                else if (ALUSrcA[31] == 1 && ALUSrcB[31]==0)  result = 1;
                else result = 0;
		    end
		endcase 
	end
	assign zero = (result == 0) ? 1 : 0;
	assign sign = (result[31] == 0) ? 0 : 1;
endmodule