module top_module(
					  
						clk,
						rst,
					  
						y1,
						y2
					  );input clk, rst;



output y1, y2;




reg y1, y2;





















always @(clk, rst)
begin 
	if(rst) y2 =1;
	else y2 = y1;
end


always @(clk, rst)
begin 
	if(rst) y1 =0;
	else y1 = y2;
end




endmodule