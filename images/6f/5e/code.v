module top_module(
    input rst,
	 input [1:0] en,
    input [7:0] Cambio,
	 input got_data,
    input clk,
    output reg [(N-1):0] Cuenta
    );parameter N = 6;
	 parameter X = 59;

    always @(posedge clk)
	 if (en == 2'd0)
	 begin 
       if (rst)
         Cuenta <= 0;
       else if (Cambio == 8'h75 && got_data)
				  begin
				     if (Cuenta == X)
						   Cuenta <= 0;
					  else 
						   Cuenta <= Cuenta + 1'd1;
				  end
				else if (Cambio == 8'h72 && got_data)
					  begin
				        if (Cuenta == 0)
						     Cuenta <= X;
					     else 
						     Cuenta <= Cuenta - 1'd1;
				     end
					  else 
					     Cuenta <= Cuenta;
	 end
	 else Cuenta <= Cuenta;
endmodule