module top_module(
	input clk,
	input resetn,
	input [3:0] KEY,
	output reg [3:0] key_pressed,
	output reg [3:0] key_held,
	output reg [3:0] key_released
);reg [3:0] prev_state;
	
always @(posedge clk)
begin
	if (!resetn) begin
		prev_state <= 4'd0;
		key_pressed <= 4'd0;
		key_held <= 4'd0;
		key_released <= 4'd0;
	end
	else begin
		key_pressed <= ~KEY & (~prev_state);
		key_held <= ~KEY;
		key_released <= KEY & prev_state;
		prev_state <= ~KEY;
	end
end
	
endmodule