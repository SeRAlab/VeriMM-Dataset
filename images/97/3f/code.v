module top_module(Q, CLK, RST, LD, CE, D);output [15:0] Q;
input CLK, RST, LD, CE;
input [15:0] D;
reg [15:0] Q;

always @ (posedge RST or posedge CLK)
begin
	if (RST)	
		Q = 0;
	else if (LD)	
		Q = D;
	else if (CE) 	
		Q = Q + 1;
end

endmodule