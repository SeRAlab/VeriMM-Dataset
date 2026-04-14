module top_module(clk,check,stop,toneIn,buzzOut);input clk;
input[14:0] toneIn;
output reg buzzOut;
input check;
input stop;

reg clk1;
reg [4:0]clkCount;
reg [14:0] i=0;

always @ (posedge clk)
begin
 	clkCount<=clkCount+1;
 	if(clkCount==5)
 	begin
  		clkCount<=0;
  		clk1<=~clk1;
 	end
end
always @ (posedge clk1)
begin
	if(check == 1  && stop == 0)
	begin
		if(i==toneIn)
	 	begin
	  		i<=0;
	  		buzzOut<=!buzzOut;
	 	end
	 	else
	 	 	i<=i+1;
	end
	else
		buzzOut <= 1;	
end
endmodule