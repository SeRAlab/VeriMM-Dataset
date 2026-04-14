module Ibniz_generator3 ( clk, rst, ena, T_in, X_in, Y_in, V_out );
input clk;
input rst;
input ena;
input wire signed [31:0] T_in;
input wire signed [31:0] X_in;
input wire signed [31:0] Y_in;
output reg [31:0] V_out;
always@(posedge clk or posedge rst)
begin
	if ( rst )
	begin
	end
	else if ( ena )
	begin
		V_out= ((((X_in>>>4) * (Y_in>>>4))>>>8) * (T_in>>>16));
	end
end
endmodule