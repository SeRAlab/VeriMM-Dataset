module top_module(
    input clk,
    input reset,
    output reg [3:0] salida
    );always @ (posedge reset or posedge clk)
	 begin
		if(reset)
			salida = 4'b0000;
		else
			salida = salida + 1;
	 end
endmodule