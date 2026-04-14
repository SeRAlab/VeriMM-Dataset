module top_module(
    input Clock,
    input Reset,
    input [7:0] Cmd,
    input OutputEnable,
    output AnalogPowerEnable
    );localparam POWER_OFF = 1'b0,
				  POWER_ON = 1'b1;
		
	reg CurrentState = POWER_OFF;
	reg NextState = POWER_OFF;

	assign AnalogPowerEnable = (OutputEnable && (CurrentState == POWER_ON));

	
	
	
	always@(posedge Clock) begin
		if(Reset) CurrentState <= POWER_OFF;
		else CurrentState <= NextState;
	end

	
	
	
	always@(*) begin
		NextState = CurrentState;
		case (CurrentState) 
			POWER_ON: begin
				if ((Cmd == 8'd112) || (OutputEnable == 0)) NextState = POWER_OFF; 
			end
			POWER_OFF: begin
				if ((Cmd == 8'd80) && (OutputEnable == 1)) NextState = POWER_ON; 
			end
		endcase
	end
endmodule