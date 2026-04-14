module top_module(
	input clk, adj_clk,
	input wire adjust,
	output clock
    );reg clock_reg;

always @* begin
	if (adjust == 0) 
		clock_reg = clk;
	else 
	    clock_reg = adj_clk;

end

assign clock = clock_reg;

endmodule