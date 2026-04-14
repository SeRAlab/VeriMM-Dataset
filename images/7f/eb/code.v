module top_module(
	input clk,
	input [6:0] wrusedw,
	output reg rdreq
	);always @(posedge clk)
begin
	if(wrusedw > 8'd10)
		rdreq <= 1'b1;
	else
		rdreq <= 1'b0;
end


endmodule