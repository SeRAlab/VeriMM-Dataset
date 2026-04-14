module top_module(

input [7:0] direccion,
input [7:0] dato,
input seleccion,
output [7:0] salida_bus

    );assign salida_bus = seleccion ? dato : direccion;

endmodule