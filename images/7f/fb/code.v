module top_module(input [3:0] dato_guardado, input [3:0] dato_leido, 
						input realizar_comparacion, output datos_iguales);reg resultado_comparacion;

always @ (posedge realizar_comparacion)
begin
if (dato_guardado == dato_leido)
	resultado_comparacion = 1'b1;
else
	resultado_comparacion = 1'b0;
end

assign datos_iguales = resultado_comparacion;
endmodule