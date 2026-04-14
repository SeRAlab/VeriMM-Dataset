module top_module(clk, rst, carry, out);input				clk;
	input				rst;
	input				carry;
	output reg [7:0]	out;
	
	always @(posedge clk) begin
		if (!rst) begin
			out = 8'b00000000;
		end
		if (out == 8'd2 && carry == 1)	out = 8'b00000000;
		else	out = out + carry;
	end

endmodule