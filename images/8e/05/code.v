module top_module(
	intrIn, intr,
	ack, clk, rst
);input intrIn;
	output intr;
	input ack;
	input clk, rst;
	
	reg intr_r;
	
	always @(posedge clk) begin
		if (rst) begin
			intr_r <= 1'b0;
		end
		else if (ack) begin
			intr_r <= 1'b0;
		end
		else begin
			intr_r <= intr_r | intrIn;
		end
	end 
	
	assign intr = intr_r;endmodule