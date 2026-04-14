module top_module(input clk, output divClk);parameter n = 25;
	reg [n-1:0] count = 0;
	assign divClk = count[n-1];
	
	always @(posedge clk)
		count <= count + 1;
endmodule