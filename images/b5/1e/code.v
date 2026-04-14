module top_module(shiftOut , charStatus , enable , clk);input enable , clk;
	output charStatus , shiftOut;

	reg [7:0] count;
	
	
	
	always @(posedge clk)
	begin
		if(enable)
		begin
			count = count + 8'b00000001;
		end
		else
		begin
			count = 8'b00000000;
		end
	end
	assign shiftOut = count[3] && ~count[2] && ~count[1] && ~count[0];
	assign charStatus = count[7] && ~count[6] && count[5] && ~count[4];endmodule