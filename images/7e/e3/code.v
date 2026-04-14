module top_module(
	input clk,
	input rst,
	input [3:0] row,
	input [3:0] column,
	output reg key_pressed,
	output reg [3:0] key
);reg [3:0] keypad [0:3];

integer i;

always @(posedge clk or posedge rst) begin
	if (rst) begin
		key_pressed <= 0;
		key <= 4'h0;
		for (i = 0; i < 4; i = i + 1) begin
			keypad[i] <= 4'hF; // Initialize each element of the keypad array
		end
	end else begin
		key_pressed <= 0;
		key <= 4'h0;
		keypad[row] <= keypad[row] & ~(1 << column);
		if (~keypad[row]) begin
			key_pressed <= 1;
			key <= row;
			keypad[row] <= 4'hF; // Reset the keypad row to all 1s
		end
	end
end

endmodule