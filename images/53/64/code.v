module top_module(A,Y);input [7:0] A;
output [2:0] Y;
reg [2:0] Y;
always@(A)
begin
case (A)
	8'b01111111:Y=3'b000;
	8'b10111111:Y=3'b001;
	8'b11011111:Y=3'b010;
	8'b11101111:Y=3'b011;
	8'b11110111:Y=3'b100;
	8'b11111011:Y=3'b101;
	8'b11111101:Y=3'b110;
	8'b11111110:Y=3'b111;
	default:Y=3'bxxx;

endcase

end


endmodule