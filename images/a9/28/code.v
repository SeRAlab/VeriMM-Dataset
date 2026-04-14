module top_module(
	input wire clk,    
	input wire clk_en, 
	input wire rst,
	input wire load_en,
	input wire  [11:0] L,
	output reg	[11:0] Q
);always @ (posedge clk or posedge rst) begin
		if (rst) begin
		Q <= 12'b0;
		end
		else if(load_en) begin
		Q <= L;
		end
		else if(clk_en) begin
		Q <= Q + 1;
		end
	end

endmodule