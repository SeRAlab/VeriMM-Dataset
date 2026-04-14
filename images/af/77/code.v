module top_module(
	clk, multi,
	clk_out
);input clk;
input[31:0] multi;
output reg clk_out;


reg[31:0] cnt;

always @ (posedge clk)
begin
	cnt = cnt + 1;
	
	
	
	if (cnt > multi/2) 
    
	begin
		clk_out = ~ clk_out;
		cnt = 0;
	end
end

endmodule