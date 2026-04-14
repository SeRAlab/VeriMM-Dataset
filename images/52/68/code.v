module top_module(in15, extendido);input [8:0]in15;
	
	output reg [31:0]extendido;
	always @( * ) begin
		
				if(in15[8] == 1)begin 
					extendido = {23'b11111111111111111111111,in15};
				end else
					extendido = {23'b00000000000000000000000,in15};
	
	end
	
endmodule