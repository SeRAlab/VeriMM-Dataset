module top_module(clock,botonLimpio,impulso);input clock,botonLimpio;
output reg impulso;

reg valorAntiguo=0;
reg valorNuevo=0;

always@(negedge clock)begin
				
				if((valorAntiguo==0)&&(botonLimpio==1))begin 
					impulso<=1; valorAntiguo <= botonLimpio;end
				else begin impulso<=0; valorAntiguo <= botonLimpio;valorNuevo<=0;end
				   
end

endmodule