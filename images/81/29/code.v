module top_module(ALUOp,funct,ALUCon);input [1:0] ALUOp;
	input [5:0] funct;
	output [3:0] ALUCon;

	reg [3:0] ALUCon;

	always @(*) begin
		case(ALUOp)
			2'b00: ALUCon <= 4'b0010;    
			2'b01: ALUCon <= 4'b0110;    
            2'b10 :
              begin
                case (funct)
                  6'b100000: ALUCon <= 4'b0010;
                  6'b100010: ALUCon <= 4'b0110;
                  6'b100101: ALUCon <= 4'b0001;
                  6'b100100: ALUCon <= 4'b0000;
                  6'b101010: ALUCon <= 4'b0111;
                  default: 	 ALUCon <= 4'b0000;
                endcase
              end
			default: ALUCon <= 4'b0000;
		endcase
	end

endmodule