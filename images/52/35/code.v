module top_module(clk, clockOut);parameter frequency = 50000000;

	input clk;
	output clockOut;
	reg clockOutReg = 0;
	
	assign clockOut = clockOutReg;
	
	reg[31:0] counter = 0;

	always @ (posedge clk) begin
		counter <= counter + 1;
		if(counter == frequency) begin
			clockOutReg <= ~clockOutReg;
			counter <= 32'd0;
		end
	end 

endmodule