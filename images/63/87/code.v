module top_module(Clock, NextAddress, Reset, RAMaddress);input Clock, NextAddress, Reset;
	output reg [5:0] RAMaddress;
	
	always @ (posedge Clock or posedge Reset)
	if (Reset == 1) RAMaddress <= 0;
	else if (NextAddress) RAMaddress <= RAMaddress + 1;
endmodule