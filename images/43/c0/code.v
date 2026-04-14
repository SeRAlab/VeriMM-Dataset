module top_module(input [2:0]s,
						input [31:0]I0,
						input [31:0]I1,
						input [31:0]I2,
						input [31:0]I3,
						input [31:0]I4,
						input [31:0]I5,
						input [31:0]I6,
						input [31:0]I7,
						
						output reg[31:0]o
						);always@*			

case(s)
	3'b000:
		begin
		o<=I0;end
	3'b001:
		begin
		o<=I1;end
	3'b010:
		begin
		o<=I2;end
	3'b011:
		begin
		o<=I3;end
	3'b100:
		begin
		o<=I4;end
	3'b101:
		begin
		o<=I5;end
	3'b110:
		begin
		o<=I6;end
	3'b111:
		begin
		o<=I7;end
		endcase

endmodule