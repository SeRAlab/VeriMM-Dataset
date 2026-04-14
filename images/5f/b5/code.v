module top_module(clk ,rst,pause, quick ,sel);input clk, rst, pause;
	input quick;
	output [1:0] sel;
	reg [9:0] count; 
	reg [1:0] sel;
	reg pattern;
	
	always@(posedge clk or posedge pause)begin
		if (pause) begin
			count <= count;
			sel <= sel;
		end
		else if(~quick) begin
			if (count == 1023) begin
				count <= 0;
				sel <= count[9:8];
			end
			else begin
				count <= count + 1;
				sel <= count[9:8];
			end
		end
		else begin
			if (count == 1023) begin
				count <= 0;
				sel <= count[8:7];
			end
			else begin
				count <= count + 1;
				sel <= count[8:7];
			end
		end
	end
	
endmodule