module top_module(
	input nReset,
	input fx3_clock,
	input readData,
	
	output fx3isReading
);reg [3:0]sm_currentState;
reg [3:0]sm_nextState;

parameter [3:0] state_waitForRequest	= 4'd01;
parameter [3:0] state_sendPacket			= 4'd02;


always @(posedge fx3_clock, negedge nReset) begin
	if(!nReset) begin 
		sm_currentState <= state_waitForRequest;
	end else begin
		sm_currentState <= sm_nextState;
	end	
end



reg readData_flag;

always @(posedge fx3_clock, negedge nReset) begin
	if(!nReset) begin 
		readData_flag <= 1'b0;
	end else begin
		readData_flag <= readData;
	end	
end



reg [15:0] wordCounter;

always @(posedge fx3_clock, negedge nReset) begin
	if (!nReset) begin
		wordCounter = 16'd0;
	end else begin
		if (sm_currentState == state_sendPacket) begin
			wordCounter = wordCounter + 16'd1;
		end else begin
			wordCounter = 16'd0;
		end
	end
end


assign fx3isReading = (sm_currentState == state_sendPacket) ? 1'b1 : 1'b0;


always @(*)begin
	sm_nextState = sm_currentState;
	
	case(sm_currentState)
		
		
		state_waitForRequest:begin
			
			if (readData_flag == 1'b1 && wordCounter == 16'd0) begin
				sm_nextState = state_sendPacket;
			end else begin
				
				sm_nextState = state_waitForRequest;
			end
		end
		
		
		state_sendPacket:begin
			if (wordCounter == 16'd8191) begin
				
				sm_nextState = state_waitForRequest;
			end else begin
				
				sm_nextState = state_sendPacket;
			end
		end
		
	endcase
end


endmodule