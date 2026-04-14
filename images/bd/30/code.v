module top_module(
	input clk,
	input reset,
	input in,
	output reg [7:0] count);reg last_in;
reg [7:0] temp_count;
			
	always @(posedge clk or posedge reset) begin
		if (reset) begin
			count <= 0;
			temp_count <= 0;
			last_in <= 0;
		end else begin
			if (last_in == 0 && in == 1) begin
				count <= temp_count;
				temp_count <= 0;
			end else begin
				temp_count <= temp_count + 1;
			end
			last_in <= in;
		end
	end
	
endmodule