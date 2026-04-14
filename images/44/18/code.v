module top_module(
    input rst,
    input [7:0] Cambio,
	 input got_data,
    input clk,
    output reg [(N-1):0] Cuenta
    );parameter N = 2;
	 parameter X = 2;

    always @(posedge clk)
       if (rst)
         Cuenta <= 0;
       else if (Cambio == 8'h7A && got_data)
				  begin
				     if (Cuenta == X)
						   Cuenta <= 0;
					  else 
						   Cuenta <= Cuenta + 1'd1;
				  end
				else if (Cambio == 8'h69 && got_data)
					  begin
				        if (Cuenta == 0)
						     Cuenta <= X;
					     else 
						     Cuenta <= Cuenta - 1'd1;
				     end
					  else 
					     Cuenta <= Cuenta;
endmodule