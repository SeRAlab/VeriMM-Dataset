module top_module(clk, rst, A,Aout);input A;
	input clk;
	input rst;
	output Aout;
	reg Aout,Bout;
	reg [21:0] counter;

	always @(clk) begin
		if (rst) begin
			counter = 0;
			end
		else begin
			counter = counter +1;
			end
		end
	
	always @(counter) begin
		if (counter == 1_000_000)begin
			Aout = A;
			end
		else begin
			Aout = 0;
			end
		end


		
endmodule