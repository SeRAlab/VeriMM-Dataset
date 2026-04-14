module top_module(clk_in,clk_out);output clk_out;
input  clk_in;
reg clk_out;

integer cnt=0;

always @(posedge clk_in)
begin
	if(cnt<499) 
	
	  begin
		cnt = cnt + 1;
		clk_out <= 1'b0;
	  end
	else
	  begin
	    cnt = 0;
		clk_out <= 1'b1;
	  end
end
endmodule