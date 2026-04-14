module top_module(input clk, input reset, input in, output p);reg [2:0] count;
	always @(posedge clk or posedge reset) begin
		if(reset)
			count <= 0;
		else begin
			if(in)
				count <= count + 1;
			else
				count <= 0;
		end
	end
	assign p = (count == 5);
endmodule