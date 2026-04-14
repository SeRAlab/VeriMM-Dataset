module top_module(
	input clk,
	input [31:0]wdata,
	input we,
	output reg [31:0]send_ena = 32'b0
);always @(negedge clk) begin
		if(we) begin
			send_ena <= wdata;
		end else begin
			send_ena <= send_ena;
		end
	end
endmodule