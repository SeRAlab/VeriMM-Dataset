module top_module(
	input clk,
	input tempReady,
	output reg load,
	output reg compareData
    );parameter loadValues = 0, compare = 1, waitSensor = 2;
	reg[1:0] current_state;
	reg[1:0] next_state;

	always @ ( current_state or tempReady )
	begin		
		case ( current_state )

		loadValues: begin
			load = 1;
			compareData = 0;
			next_state <= compare;
		end

		compare: begin
			load = 0;
			compareData = 1;
			next_state <= waitSensor;
		end

		waitSensor: begin
			load = 0;
			compareData = 0;
			if ( tempReady == 1 )
			begin
				next_state <= loadValues;
			end
		end
		
		default: begin
			next_state <= waitSensor;
		end
	
		endcase
	end

	always @(negedge clk) 
	begin
		current_state <= next_state;
	end

endmodule