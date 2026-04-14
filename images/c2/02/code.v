module counter_3bit(
	input clk,
	input reset,
	input enable,
	output reg [2:0] count
);

	always @(posedge clk or negedge reset) begin
		if(!reset) begin
			count <= 3'b0;
		end else if(enable) begin
			count <= count + 1;
		end
	end

endmodule