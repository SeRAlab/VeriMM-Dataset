module up_counter(clk, reset, load, data, count);

	input clk, reset, load;
	input [3:0] data;
	output reg [3:0] count;
	
	always @(posedge clk) begin
		if (reset == 0) begin
			count <= 4'b0;
		end
		else if (load == 1) begin
			count <= data;
		end
		else begin
			count <= count + 1;
		end
	end
	
endmodule