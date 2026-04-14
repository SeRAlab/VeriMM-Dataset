module top_module(clk, a_reset, enable, count);input clk, a_reset, enable;
output reg [3:0] count;

always @(posedge clk or posedge a_reset)
begin
	if(a_reset == 1'b1) 
		count = 4'b0000; 
	else if(enable)		
	begin				
		if(count == 4'b1010)
			count = 4'b0000; 
		else
			count = count + 1; 
	end
end

endmodule