module top_module(
	input clk,
	input enable,
	input S,
	
	input A, B, C,
	output reg Z
);reg [7:0] q;
	
	
	


	
	
	
	assign Z = q[ {A, B, C} ];



	
	
	always @(posedge clk) begin
		if (enable)
			q <= {q[6:0], S};	
	end
	
	
	
endmodule