module top_module(tempGateStatus, currentIndex, changeButton, passwordUnlockAttempt, currentPasswordRequiredToUnlock, newGateStatus, newIndex, changeUpdatePassword);input [2:0] tempGateStatus;
	input [1:0] currentIndex;
	
	input changeButton;
	
	input [15:0] passwordUnlockAttempt;
	input [15:0] currentPasswordRequiredToUnlock;
	
	output reg [15:0] changeUpdatePassword;
	
	output reg [2:0] newGateStatus;
	output reg [1:0] newIndex;
	

	
	always@(posedge changeButton) begin
		changeUpdatePassword <= currentPasswordRequiredToUnlock;
		case(tempGateStatus)
		
			3'd1: begin
				newGateStatus <= 3'd4;
				newIndex <= 2'd0;
			end
			
			3'd5: begin
				newGateStatus <= 3'd4;
				newIndex <= 2'd0;
			end
			
			default: begin
				newGateStatus <= tempGateStatus;
				newIndex <= currentIndex;
			end
		endcase
	end


endmodule