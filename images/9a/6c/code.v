module top_module(state, workload, enable, clk);input [2:0] state; 
input [5:0] workload; 
output enable; 
input clk; 
reg enable_reg;
assign enable = enable_reg;

always @ (posedge clk)
begin
	if(state == 0 && workload == 0 ) 
	begin
		enable_reg = 1;		
	end
	else 
	begin
		enable_reg = 0;
	end
end

endmodule