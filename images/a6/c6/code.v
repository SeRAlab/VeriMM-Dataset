module sync_counter (
	input clock,
	input reset,
	output reg [3:0] counter);always @(posedge clock) begin
		if (reset)
			counter <= 4'b0000;
		else
			counter <= counter + 1;
	end
	
	initial counter = 4'b0000;
endmodule