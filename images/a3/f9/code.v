module top_module(input wire C, input wire D, output reg Q, output reg nQ);always@(posedge C)
	begin
		Q = D;
		nQ = ~D;
	end
endmodule