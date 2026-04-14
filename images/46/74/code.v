module top_module(input clk, rst, ldN, input[7:0] N, output  [7:0] O);reg [7:0] o ;
	always@(posedge clk, posedge rst) begin
		if(rst) o <= 8'b0;
		else
			if(ldN) o <= N;
			else o <= o;
	end
	assign O = o;
	
endmodule