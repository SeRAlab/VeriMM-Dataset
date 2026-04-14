module top_module(input [5:0] opcode, output reg [1:0] WB, output reg [2:0] M, 
	output reg [3:0] EX);always @ *
	begin
		case (opcode)
			6'b000000:  
				begin
					WB <= 2'b10;
					M  <= 3'b000;
					EX <= 4'b1100;
				end					
			6'b100011:  
				begin
					WB <= 2'b11;
					M  <= 3'b010;
					EX <= 4'b0001;
				end					
			6'b101011: 
				begin
					WB <= 2'b0x;
					M  <= 3'b001;
					EX <= 4'bx001;
				end					
			6'b000100:  
				begin
					WB <= 2'b0x;
					M  <= 3'b100;
					EX <= 4'bx010;
				end
			6'b100000:	
				begin
					WB <= 2'b00;
					M  <= 3'b000;
					EX <= 4'b0000;
				end
		endcase
	end
endmodule