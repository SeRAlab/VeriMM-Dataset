module top_module(entrada,Tx,clock,X);input wire [3:0] entrada;
input wire [3:0] Tx;
input wire clock;
output reg [3:0] X;

parameter CLEAR = 4'd0;
parameter HOLD = 4'd1;
parameter LOAD = 4'd2;

always @(posedge clock)begin
	case(Tx)
		CLEAR:begin
			X = 4'd0;
		end
		HOLD:begin 
			X = X;
		end
		LOAD:begin
			X = entrada;
		end 
	endcase
end		
endmodule