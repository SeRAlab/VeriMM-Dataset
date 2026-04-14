module top_module(
input [2:0] state,					
input [3:0] digit1,					
input [3:0] digit2,					
input [3:0] digit3,					
input [3:0] digit4,					
input [3:0] digit5,					
input [3:0] digit6,					
input [3:0] digit7,					
input [3:0] digit8,					
input [2:0] position_pointer,		
input [2:0] refreshcounter,		
output reg [3:0] ONE_DIGIT = 0,	
output reg position_pointer_now=0
);always@(refreshcounter)
	begin
		case(refreshcounter)
			3'd0:
				ONE_DIGIT = digit1;	
			3'd1:
				ONE_DIGIT = digit2;	
			3'd2:
				ONE_DIGIT = digit3;	
			3'd3:
				ONE_DIGIT = digit4;	
			3'd4:
				ONE_DIGIT = digit5;	
			3'd5:
				ONE_DIGIT = digit6;	
			3'd6:
				ONE_DIGIT = digit7;	
			3'd7:
				ONE_DIGIT = digit8;	
		endcase
		
		if(position_pointer == refreshcounter && (state == 3'd0 || state == 3'd1 || state == 3'd3))
			position_pointer_now = 1;	
		else
			position_pointer_now = 0;	
	end

endmodule