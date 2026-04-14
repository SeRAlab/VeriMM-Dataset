module johnson_counter (
	input clk,
	input reset_n,
	output reg [7:0] q);always @(posedge clk or negedge reset_n) begin
		if (!reset_n)
			q <= 8'b00000001;
		else begin
			q[7] <= q[0];
			q[6:0] <= q[7:1];
		end
	end
	
endmodule