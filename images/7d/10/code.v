module top_module(
    input wire [2:0] act_add,
	 input wire [7:0] fila7,
	 input wire [7:0] fila6,
	 input wire [7:0] fila5,
	 input wire [7:0] fila4,
	 input wire [7:0] fila3,
	 input wire [7:0] fila2,
	 input wire [7:0] fila1,
	 input wire [7:0] fila0,
    output reg [7:0] max_in
    );reg [2:0] aux;
always@(*)
begin
	aux = act_add;	
	case (aux)
	  3'b000 : max_in = fila7;
	  3'b001 : max_in = fila6;
	  3'b010 : max_in = fila5;
	  3'b011 : max_in = fila4;
	  3'b100 : max_in = fila3;
	  3'b101 : max_in = fila2;
	  3'b110 : max_in = fila1;
	  3'b111 : max_in = fila0;
	  default: max_in = 8'b00000000;
	endcase
end
endmodule