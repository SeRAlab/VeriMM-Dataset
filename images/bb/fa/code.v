module top_module(L, D, C, clk, BusIn, BusOut);input L, D, C;
input clk;
input [3:0] BusIn;
output [3:0] BusOut;
reg [3:0] BusOut;

always@ (posedge clk)
begin
	if(clk)
		begin
			if(L)
			begin
				BusOut <= BusIn;
			end
			if(C)
			begin
				BusOut <= 0;
			end
			if (D)
			begin
				BusOut <= BusOut - 4'b0001;
			end
		end
end
endmodule