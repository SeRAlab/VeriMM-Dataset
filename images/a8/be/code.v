module top_module(BranchSelect, ULAout, LineSelection);input [31:0] ULAout;
	input [2:0] BranchSelect;
	output reg LineSelection;

	always @ (*) begin
		
		case(BranchSelect[2:0])
			3'b000: LineSelection = 1;
			3'b001: 
				if (ULAout == 0) 
					LineSelection = 1;
				else
					LineSelection = 0;
			3'b010: 
				if (ULAout != 0) 
					LineSelection = 1;
				else
					LineSelection = 0;
			3'b011:
				if ($signed(ULAout) > 0) 
					LineSelection = 1;
				else
					LineSelection = 0;
			3'b100:
				if ($signed(ULAout) < 0) 
					LineSelection = 1;
				else
					LineSelection = 0;
			3'b101: LineSelection = 0; 
			default: LineSelection = 0;
		endcase
		
	end
endmodule