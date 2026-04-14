module top_module(inclk,outclk,clk_count_to);input inclk;
	input [31:0] clk_count_to;
	output reg outclk=0;
	reg [31:0] count;
	

	
always @(posedge inclk) begin
	if(count<(clk_count_to-1))  
	count = count+1;
	else begin  
	outclk=!outclk;  
	count =0;   
	end
end
endmodule