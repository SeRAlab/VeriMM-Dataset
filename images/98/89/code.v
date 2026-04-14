module top_module(input clk, input reset, input [3:0] in, output reg p);always @(posedge clk or posedge reset) begin
	if(reset)
		p <= 0;
	else begin
		if(in == 4'b0010)
			p <= 1;
		else
			p <= 0;
	end
end

endmodule