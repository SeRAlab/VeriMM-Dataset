module top_module(
	reset,
	clk,
	in,
	curr_out,
	read_out,
	we,
	bank,
	ureg,
	CRY,
	setCRY
);input reset, clk, we, bank, CRY, setCRY, ureg;
input [7:0] in;
output [7:0] curr_out, read_out;

reg [7:0] uCR, sCR;

assign curr_out = (bank == 0) ? uCR : sCR;

assign read_out = (ureg) ? uCR :
									(bank == 0) ? uCR : sCR;

always @(posedge clk) begin

	if (reset) begin
		uCR <= 8'h8;
		sCR <= 8'h1;
	end else if (we) begin
		if (bank == 0 || ureg)
			uCR <= in;
		else
			sCR <= in;
	end else if (setCRY) begin
		if (bank == 0)
			uCR[1] <= CRY;
		else
			sCR[1] <= CRY;
	end
end


endmodule