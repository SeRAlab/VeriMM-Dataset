module top_module(
	input clk,
	input clear,
	input gate,
	input [7:0] din,
	output [7:0] sum,
	output all_ones
);reg [7:0] chksum=0, chksum1=0;
reg chksum_carry=0;
always @(posedge clk) begin
	if (clear) {chksum_carry, chksum} <= 9'h0;
	else if (gate) {chksum_carry, chksum} <=
		chksum1 + din + chksum_carry;
	if (clear) chksum1 <= 8'h0;
	else if (gate) chksum1 <= chksum;
end
assign sum = ~(chksum1 + chksum_carry);
assign all_ones = &chksum;

endmodule