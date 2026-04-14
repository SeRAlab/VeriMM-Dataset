module up_down_counter (
	input clock,
	input up_down,
	output reg [2:0] counter);always @(posedge clock) begin
		if (up_down)
			counter <= counter + 1;
		else
			counter <= counter - 1;
	end
	
	initial counter = 3'b000;
endmodule