module top_module(clk, rst, en, count);input clk, rst, en;
output reg [3:0] count;

always @(posedge clk, posedge rst) begin
	if (rst == 1) begin
		count <= 0;
	end
	else if (en == 1) begin
		count <= count + 1;
	end
end

endmodule