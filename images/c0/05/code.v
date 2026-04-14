module Ibniz_generator1 ( clk, rst, ena, T_in, X_in, Y_in, V_out );
input clk;
input rst;
input ena;
input wire signed [31:0] T_in;
input wire signed [31:0] X_in;
input wire signed [31:0] Y_in;
output reg [31:0] V_out;
wire [31:0] XxY= X_in^Y_in;
always@(posedge clk or posedge rst)
begin
	if ( rst )
	begin
	end
	else if ( ena )
	begin
		V_out= XxY+ (T_in>>7) + (T_in<<(32-7));
	end
end
endmodule