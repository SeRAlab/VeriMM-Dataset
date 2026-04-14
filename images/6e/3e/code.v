module top_module(control,instruction,ALUOp);input [5:0] instruction;
	input [2:0] ALUOp;
	output reg [2:0] control;
	
	always@(*)begin
		case(ALUOp)
			
			3'b0: control = 3'b001;
			
			3'b001: control = 3'b010;
			
			3'b010: begin 
				if (instruction == 6'b0) control = 3'b0;
				else if (instruction == 6'b100000) control = 3'b001;
				else if (instruction == 6'b100010) control = 3'b010;
				else if (instruction == 6'b100100) control = 3'b011;
				else if (instruction == 6'b100101) control = 3'b100;
				else if (instruction == 6'b100110) control = 3'b101;
				else if (instruction == 6'b101010) control = 3'b110;
				else if (instruction == 6'b000001) control = 3'b111;
				else control =3'b0;
			end
			3'b011: control = 3'b011;
			3'b100: control = 3'b101;
			3'b101: control = 3'b100;
			
			default: control =3'b0;
			endcase
				
	end
	
endmodule