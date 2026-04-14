module top_module(
	input [7:0] x,
	input [6:0] y,
	input [19:0] delay_q,
	input clk,
	input resetn,
	output reg [2:0] colourout,
	output [7:0] xout,
	output [6:0] yout);reg [3:0] count;
	
	always @(posedge clk) begin
		if (!resetn) begin
			count <= 4'd0;
		end
		else
			count <= count + 1;
	end
			
	always @(posedge clk) begin
		if (!resetn) begin
			colourout <= 3'd0;
		end
		else begin
			if (delay_q < 20'd830000) begin
				colourout <= 3'd0;
			end
			else begin
				colourout <= 3'd1;
			end
		end
	end

	assign xout = x + count[1:0];
	assign yout = y + count[3:2];endmodule