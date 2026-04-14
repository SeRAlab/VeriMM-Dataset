module top_module (
	input clk,
	input reset,
	output reg [3:0] johnson);always @(posedge clk) begin
		if (reset)
			johnson <= 4'b0001;
		else
			johnson <= {johnson[2:0], ~johnson[3]};
	end
	
endmodule