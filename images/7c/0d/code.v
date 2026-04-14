module top_module(clk,registradorin, registradorout);input [15:0] registradorin;
	input clk;
	
	
	
	output [15:0]registradorout;
	
	
	
	reg [15:0]registradorout;
	reg[3:0] del;
	reg[3:0] del2;
	reg[3:0] del3;
	reg[3:0] del4;
	
	
	always @(*) begin
		del <= registradorin[3:0];
		del2 <= registradorin[7:4];
		del3 <= registradorin[11:8];
		del4 <= registradorin[15:12];
		registradorout <= del + (del2*10) + (del3*100) + (del4*1000);
	end
	
endmodule