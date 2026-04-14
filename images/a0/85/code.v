module top_module(
	input clk,
	input rst,
	input down,
	output reg [3:0] q
);always @(posedge clk)
begin
	if(rst) q <= 4'd15;
	else
	begin
		if(down) q <= q - 1'b1;
		else q <= q;
	end
end

endmodule