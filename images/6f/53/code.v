module top_module(input [31:0]In, input [2:0]Pattern,output reg[31:0]CountOut);integer i_count; 
always @(In) 
begin 
	CountOut = 0; 
	for (i_count = (0); i_count <30; i_count=i_count+1)
		if ( Pattern[0]==In[i_count] && Pattern[1]==In[i_count+1] && Pattern[2]==In[i_count+2] )
			begin
			CountOut = CountOut + 1; 
			end 		
			
		else
		begin
			CountOut = CountOut + 0; 
		end
	
end
endmodule