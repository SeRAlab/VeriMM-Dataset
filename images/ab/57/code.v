module top_module(
	input clk,
	input cein,
	input enable,
	input wdreset,
	input wdogdis,
	input [7:0] wdogdivreg,
	output wdtripce);reg [7:0] counter = 0;
	reg wdtripcesreg = 0;
	reg wdtripcereg = 0;
	reg wdogdisreg = 0;
	
	
	assign wdtripce = wdtripcesreg;
	
	always @(*) begin
		if ((wdogdivreg == counter) && ~wdreset && enable && ~wdogdisreg)
			wdtripcereg <= cein;
		else
			wdtripcereg <= 0;
	end
	
	always @(posedge clk) begin
		
		wdtripcesreg <= wdtripcereg;
		
		wdogdisreg = wdogdis;
		
		
		if(enable & ~wdreset & ~wdogdisreg) begin
			if(cein)
				counter <= counter + 1;
		end
		else
			counter <= 8'h00;
	end
endmodule