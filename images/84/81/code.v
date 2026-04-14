module top_module(input [1:0] interruptor_sinc,
		output [3:0] datos_por_escribir, input [3:0] direccion_actual
    );reg [3:0] datos;

always@(interruptor_sinc or direccion_actual)
begin
case(interruptor_sinc)
	2'b00: datos = 4'b0101;
	2'b01: datos = 4'b1010;
	2'b10: datos = 4'b1111;
	default: datos = direccion_actual;
endcase
end

assign datos_por_escribir = datos;
endmodule