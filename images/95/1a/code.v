module johnson_counter (
	input clk,
	input reset,
	output reg [3:0] q);

	always @(posedge clk or posedge reset) begin
		if (reset) 
			q <= 4'b0000;
		else begin
			q <= {~q[0], q[3:1]};
		end
	end
	
endmodule