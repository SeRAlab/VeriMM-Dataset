module top_module(input [5:0] funct, input [1:0] alu_op, output reg [2:0] select);always @ * 
	begin
		case (alu_op) 
			2'b00: 
				begin
					select <= 3'b010;            
				end
			2'b01: 
				begin
					select <= 3'b110;            
				end
			2'b10: 
				begin
					case (funct) 
						6'b100000: 
							begin
								select <= 3'b010;   
							end
						6'b100010: 
							begin
								select <= 3'b110;   
							end
						6'b100100: 
							begin
								select <= 3'b000;   
							end
						6'b100101: 
							begin
								select <= 3'b001;   
							end
						6'b101010: 
							begin
								select <= 3'b111;   
							end
					endcase
				end
			2'b11:
				begin
					select <= 3'b011;            
				end
		endcase
	end
endmodule