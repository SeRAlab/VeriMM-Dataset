module top_module(
	input					clock,
	input					reset,
	input			[7:0]	data,
	input					rs,
	input					write_start,
	output reg			lcd_done,
	
	
	output		[7:0]	lcd_data,
	output		[4:0]	lcd_ctrl
);parameter	SUSTAINED_PULSES	=	16;
	
	
	
	reg		[4:0]	pulse_counter;
	reg		[1:0]	state;
	reg				reg_pre_start, reg_start;
	reg				reg_lcd_en;
	

	assign	lcd_data	=	data;
	
	
	assign	lcd_ctrl = {1'b0, reg_lcd_en, rs, 1'b1, 1'b1};
	
	
	
	parameter	[1:0]	WAIT			= 2'd0,
							BEGIN			= 2'd1,
							HOLD_DATA	= 2'd2,
							END			= 2'd3;
							
	always@(posedge clock or negedge reset) begin
		if (!reset) begin
			lcd_done			<=	1'b0;
			reg_lcd_en		<=	1'b0;
			reg_pre_start	<=	1'b0;
			reg_start		<=	1'b0;
			pulse_counter	<=	5'd0;
			state				<=	WAIT;
		end
		else begin
			
			reg_pre_start <= write_start;
			if ({reg_pre_start,write_start} == 2'b01) begin
				reg_start	<=	1'b1;
				lcd_done		<=	1'b0;
			end
			
			if (reg_start) begin
				case(state)
				WAIT:	begin
					state	<=	BEGIN;
				end
				
				BEGIN: begin
					reg_lcd_en	<=	1'b1;
					state			<=	HOLD_DATA;
				end
				
				HOLD_DATA:	begin					
					if(pulse_counter < SUSTAINED_PULSES)
						pulse_counter	<=	pulse_counter+5'd1;
					else
						state				<=	END;
				end
				
				END:	begin
					reg_lcd_en		<=	1'b0;
					reg_start		<=	1'b0;
					lcd_done			<=	1'b1;
					pulse_counter	<=	0;
					state				<=	WAIT;
				end
				endcase
			end
		end
	end

endmodule