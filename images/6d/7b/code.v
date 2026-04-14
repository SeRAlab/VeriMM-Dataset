module gray_counter (
	input clock,
	output reg [2:0] gray_counter);reg [2:0] binary_counter;

	always @(posedge clock) begin
		binary_counter <= binary_counter + 1;
		gray_counter <= (binary_counter >> 1) ^ binary_counter;
	end
	
	initial begin
		binary_counter = 3'b000;
		gray_counter = 3'b000;
	end
endmodule