module ring_counter_4bit(
	input clk,
	input reset,
	output reg [3:0] out);

	always @(posedge clk or posedge reset) begin
		if (reset)
			out <= 4'b0001;
		else
			out <= {out[2:0], out[3]};
	end
	
endmodule