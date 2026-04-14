module top_module(
		input CLK,								
		input reset,
		output [9:0] cuenta					
    );reg [9:0] contador;
	 
	 always @(posedge CLK)					
		begin
		if (reset) 
			contador<=1'b0;
		else if (contador==10'd1000)
			contador <=1'b0;
		else 
			contador<=contador+7'd50;
		end

	assign cuenta=contador;

endmodule