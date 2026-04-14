module top_module(
    input clk,
    output reg clk_out = 1'b0
    );reg [9:0] counter = 10'b0; 
	 parameter count_to = 651; 

	
	always@(posedge clk)
	begin	
		if(counter == count_to) 
		begin
			counter <= 10'b0; 
			clk_out <= ~clk_out;
		end
		else
			counter <= counter + 1'b1; 
	end
endmodule