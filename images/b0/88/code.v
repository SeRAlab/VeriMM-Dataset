module top_module(
	input clock, 
	input reset, 
	input c_pad,
	input d_pad,
	input e_pad,
	input f_pad,
	input g_pad,
	output reg reset_sync,
	output reg c_pad_sync,
	output reg d_pad_sync,
	output reg e_pad_sync,
	output reg f_pad_sync,
	output reg g_pad_sync,
	output reg pad_touched   // Change output to reg to allow assignment
	);parameter DEBOUNCE_CYCLES = 10;
	
	reg [DEBOUNCE_CYCLES-1:0] c_pad_history;
	reg [DEBOUNCE_CYCLES-1:0] d_pad_history;
	reg [DEBOUNCE_CYCLES-1:0] e_pad_history;
	reg [DEBOUNCE_CYCLES-1:0] f_pad_history;
	reg [DEBOUNCE_CYCLES-1:0] g_pad_history;
	reg [4:0] pad_history;
	reg [3:0] history_counter; // Change size to avoid overflow based on DEBOUNCE_CYCLES
	
	initial begin
		reset_sync <= 0;
		c_pad_sync <= 0;
		d_pad_sync <= 0;
		e_pad_sync <= 0;
		f_pad_sync <= 0;
		g_pad_sync <= 0;
		c_pad_history <= 0;
		d_pad_history <= 0;
		e_pad_history <= 0;
		f_pad_history <= 0;
		g_pad_history <= 0;
		history_counter <= 0;
		pad_history <= 0;
		pad_touched <= 0; // Initialize pad_touched
	end
	
	always @(posedge clock) begin
		reset_sync <= reset;
		c_pad_history[history_counter] <= c_pad;
		d_pad_history[history_counter] <= d_pad;
		e_pad_history[history_counter] <= e_pad;
		f_pad_history[history_counter] <= f_pad;
		g_pad_history[history_counter] <= g_pad;

		if (history_counter < DEBOUNCE_CYCLES - 1) begin
			history_counter <= history_counter + 1; // Prevent overflow
		end else begin
			history_counter <= 0; // Reset counter after reaching DEBOUNCE_CYCLES
		end
	end
	
	always @(posedge clock) begin
		c_pad_sync <= c_pad_history[history_counter];
		d_pad_sync <= d_pad_history[history_counter];
		e_pad_sync <= e_pad_history[history_counter];
		f_pad_sync <= f_pad_history[history_counter];
		g_pad_sync <= g_pad_history[history_counter];
		
		pad_history <= {pad_history[3:0], (c_pad_sync | d_pad_sync | e_pad_sync | f_pad_sync | g_pad_sync)};
		
		if (pad_history == 5'b11111) begin
			pad_touched <= 1;
		end else begin
			pad_touched <= 0;
		end
	end
	
endmodule