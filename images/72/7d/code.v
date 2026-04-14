module top_module( input [7:0] input_value,
  output [7:0] show_value
);wire [2:0] control;
reg[7:0] dec;

assign control = input_value[2:0];
assign show_value = dec;

always@*
case (control)
	3'b000  : dec <= 8'b00000001;
	3'b001  : dec <= 8'b00000010;
	3'b010  : dec <= 8'b00000100;
	3'b011  : dec <= 8'b00001000;
	3'b100  : dec <= 8'b00010000;
	3'b101  : dec <= 8'b00100000;
	3'b110  : dec <= 8'b01000000;
	default : dec <= 8'b10000000;
endcase

endmodule