module top_module (
        input clk,
        input areset,
        input trigger_alarm,
        input reset_alarm,
        output reg alarm_on);parameter Alarm_Off=1'b0, Alarm_On=1'b1;
	reg state;
	always @(posedge clk, posedge areset) begin
		if (areset)
			state <= Alarm_Off;
		else begin
			case (state)
				Alarm_Off: state <= trigger_alarm ? Alarm_On : Alarm_Off;
				Alarm_On: state <= reset_alarm ? Alarm_Off : Alarm_On;
			endcase
		end
	end
	
	assign alarm_on = (state == Alarm_On);
	
endmodule