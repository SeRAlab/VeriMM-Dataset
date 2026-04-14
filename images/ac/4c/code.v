module top_module(
	input clk, rst,
    input [N-1:0]key_code, 
	 input got_code_tick, 
	 output reg [P-1:0] posicion 
    );parameter N=8;
	parameter P=2;
   always @ (posedge clk)
	begin
		if (rst)
			posicion <=0;
		else if (got_code_tick==1'b1)
		begin
			if (key_code==8'h74) 
			begin
				if (posicion==2'd2) 
					posicion <=0;
				else
					posicion <= posicion + 1'd1;
			end
			else if (key_code==8'h6B) 
			begin
				if(posicion==0)
					posicion <=2'd2;
				else
					posicion <= posicion - 1'd1;
			end 
			else 
				posicion <= posicion;
		end
		else 
				posicion <= posicion;
	end
	
endmodule