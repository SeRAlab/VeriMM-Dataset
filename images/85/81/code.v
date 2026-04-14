module top_module(
	 input toRight,
    input [5:0] operand,
    input [2:0] shamt,
    output reg [5:0] out
    );always @ (*) 
begin
	if (toRight == 1)
	begin
		case (shamt)
			3'd0: out <= operand;
			3'd1: out <= {1'b0, operand[5:1]};
			3'd2: out <= {2'b00, operand[5:2]};
			3'd3: out <= {3'b000, operand[5:3]};
			3'd4: out <= {4'b0000, operand[5:4]};
			3'd5: out <= {5'b00000, operand[5]};
			default: out <= 6'b000000;
		endcase
	end
	else
	begin
		case (shamt)
			3'd0: out <= operand;
			3'd1: out <= {operand[4:0], 1'b0};
			3'd2: out <= {operand[3:0], 2'b00};
			3'd3: out <= {operand[2:0], 3'b000};
			3'd4: out <= {operand[1:0], 4'b0000};
			3'd5: out <= {operand[0], 5'b00000};
			default: out <= 6'b000000;
		endcase
	end
end

endmodule