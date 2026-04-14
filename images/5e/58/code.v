module sync_counter (
	input clk,
	input srst,
	input enable,
	output reg [3:0] count);
	
	always @(posedge clk) begin
		if (srst)
			count <= 4'b0000;
		else if (enable)
			count <= count + 1;
	end

endmodule