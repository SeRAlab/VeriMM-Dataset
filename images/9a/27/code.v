module top_module (
	input clk,
	input reset,
	output reg [6:0] hours_display,
	output reg [6:0] minutes_display);reg [5:0] minutes;
	reg [4:0] hours;
	
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			minutes <= 0;
			hours <= 0;
		end else begin
			if (minutes == 59) begin
				minutes <= 0;
				if (hours == 23) begin
					hours <= 0;
				end else begin
					hours <= hours + 1;
				end
			end else begin
				minutes <= minutes + 1;
			end
		end
	end
	
	always @(*) begin
		case (hours)
			5'd0: hours_display = 7'b1000000;
			5'd1: hours_display = 7'b1111001;
			5'd2: hours_display = 7'b0100100;
			5'd3: hours_display = 7'b0110000;
			5'd4: hours_display = 7'b0011001;
			5'd5: hours_display = 7'b0010010;
			5'd6: hours_display = 7'b0000010;
			5'd7: hours_display = 7'b1111000;
			5'd8: hours_display = 7'b0000000;
			5'd9: hours_display = 7'b0010000;
			// Add cases for 10 to 23 here
			default: hours_display = 7'b1111111;
		endcase
		
		case (minutes)
			6'd0: minutes_display = 7'b1000000;
			6'd1: minutes_display = 7'b1111001;
			6'd2: minutes_display = 7'b0100100;
			6'd3: minutes_display = 7'b0110000;
			6'd4: minutes_display = 7'b0011001;
			6'd5: minutes_display = 7'b0010010;
			6'd6: minutes_display = 7'b0000010;
			6'd7: minutes_display = 7'b1111000;
			6'd8: minutes_display = 7'b0000000;
			6'd9: minutes_display = 7'b0010000;
			// Add cases for 10 to 59 here
			default: minutes_display = 7'b1111111;
		endcase
	end
	
endmodule