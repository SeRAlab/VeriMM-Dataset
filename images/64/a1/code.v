module top_module(Qout, CLK, Reset);output reg [2:0] Qout;
	input CLK, Reset;
	always @(posedge CLK or posedge Reset)
	begin
		if(Reset == 1)
			Qout <= 0;
		else if (Qout == 4)
			Qout <= 4;
		else 
			Qout <= Qout +1;
	end
endmodule