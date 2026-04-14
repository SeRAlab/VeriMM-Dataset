module top_module (
	input clk,
	input load,
	input [7:0] pdata,
	input sdata,
	output reg [7:0] q);always @(posedge clk) begin
		if (load)
			q <= pdata;
		else
			q <= {q[6:0], sdata};
	end
	
endmodule