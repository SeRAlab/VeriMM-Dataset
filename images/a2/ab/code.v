module top_module(
	input 				clock, 
	input 				reset,
	input [2:0] 		key_data, 
	input 				key_en,
	output reg [2:0]	sound_code,		
	input 				data_request,	
	output reg 			data_ready);reg wr_sound_code;
	
	
	always @(posedge clock)
		if (reset)
			sound_code <= 0;
		else if (key_en && wr_sound_code)
			sound_code <= key_data;
			
	
	reg [1:0] state;
	reg [1:0] next_state;
	
	always @( posedge clock) begin 
		if (reset) 
			state = 0;
		else
			state = next_state;
	end
	

	always @(state, data_request, key_en) begin
		wr_sound_code = 0;
		data_ready = 0;
		case(state) 
			0: begin
				wr_sound_code = 0;
				data_ready = 0;
				if (data_request)
					next_state = 1;
				else 
					next_state = 0;
				end
			1: begin 
				wr_sound_code = 1;
				if (key_en)
					next_state = 2;
				else 
					next_state = 1;
				end
			2: begin
					data_ready = 1;
					if (!data_request)
						next_state = 0;
					else 
						next_state = 2;
				end
			default: begin
				next_state = 0;
			end
		endcase
	end
endmodule