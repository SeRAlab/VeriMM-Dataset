module top_module(in,out,clk,rst);input wire clk,rst;
input wire [3:0]in;
output reg [10:0]out;


always@(posedge clk, posedge rst)
	if (rst)
		begin
		out <= 11'd0;
		end
	else
		case(in)
			4'b0000: out <= 11'd1666;
			4'b0001: out <= 11'd999;
			4'b0010: out <= 11'd666;
			4'b0011: out <= 11'd499;
			4'b0100: out <= 11'd399;
			4'b0101: out <= 11'd332;
			4'b0110: out <= 116'd285;
			4'b0111: out <= 11'd249;
			4'b1000: out <= 11'd221;
			4'b1001: out <= 11'd199;
			4'b1010: out <= 11'd181;
			4'b1011: out <= 11'd165;
			4'b1100: out <= 11'd152;
			4'b1101: out <= 11'd141;
			4'b1110: out <= 11'd132;
			4'b1111: out <= 11'd124;
			default out <= 11'd0;
		endcase
endmodule