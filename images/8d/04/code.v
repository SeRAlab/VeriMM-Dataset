module top_module(
    input clk,
    input rst,
    input load,
    input shift,
    input in,
    input [7:0] din,
    input out,
    input [7:0] dout
    );reg [7:0] shr;

always @ (posedge clk)
begin
	if (rst)
		shr <= 0;
	else if (load)
		shr <= din;
	else if (shift)
		shr <= {shr[6:0], in};
	else
		shr <= shr;
end

assign dout = shr;
assign out = shr[7];

endmodule