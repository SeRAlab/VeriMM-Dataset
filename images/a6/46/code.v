module top_module(address,out
    );input [15:0] address;
	
	output reg [15:0] out;
	
	always@(*)begin
		case(address)
			0:	out = 16'h0;
			1: out = 16'hB040;
			2:	out = 16'hB210;
			3:	out = 16'hC250;
			4:	out = 16'hBA10;
			5: out = 16'hF34B;
			6:	out = 16'hB40F;
			7:	out = 16'hB6F0;
			8:	out = 16'hBC10;
			9:	out = 16'hBE05;
			10:	out = 16'h4F18;
			11:	out = 16'h7FFF;
			12:	out = 16'h5D00;
			13:	out = 16'hBA01;
			14:	out = 16'hCB50;
			15:	out = 16'h4946;
			16:	out = 16'hD006;
			17:	out = 16'hF20B;
			18:	out = 16'hBAFF;
			19:	out = 16'hCB50;
			20:	out = 16'h6D40;
			21:	out = 16'h101A;
			22:	out = 16'hC484;
			23:	out = 16'hF69C;
			24:	out = 16'hBAFF;
			25:	out = 16'h6D40;
			26:	out = 16'h7D81;
			27:	out = 16'hF921;
			28:	out = 16'h100a;
			29:	out = 16'h0000;





































			default:	out = 16'h0;
		endcase
	end
			
endmodule