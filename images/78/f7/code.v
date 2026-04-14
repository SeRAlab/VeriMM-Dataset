module top_module(
	input [1:0]funcion_conf,
	output reg cs_seg_hora,
	output reg cs_min_hora,
	output reg cs_hora_hora,
	output reg cs_dia_fecha,
	output reg cs_mes_fecha,
	output reg cs_jahr_fecha,
	output reg cs_seg_timer,
	output reg cs_min_timer,
	output reg cs_hora_timer
    );always@*
begin
	case(funcion_conf)
		2'b00: begin
		cs_seg_hora = 1'b0;
		cs_min_hora= 1'b0;
		cs_hora_hora= 1'b0;
		cs_dia_fecha= 1'b0;
		cs_mes_fecha= 1'b0;
		cs_jahr_fecha= 1'b0;
		cs_seg_timer= 1'b0;
		cs_min_timer= 1'b0;
		cs_hora_timer= 1'b0;
			end
		2'b01: begin
		cs_seg_hora = 1'b1;
		cs_min_hora= 1'b1;
		cs_hora_hora= 1'b1;
		cs_dia_fecha= 1'b0;
		cs_mes_fecha= 1'b0;
		cs_jahr_fecha= 1'b0;
		cs_seg_timer= 1'b0;
		cs_min_timer= 1'b0;
		cs_hora_timer= 1'b0;
			end
		2'b10: begin
		cs_seg_hora = 1'b0;
		cs_min_hora= 1'b0;
		cs_hora_hora= 1'b0;
		cs_dia_fecha= 1'b1;
		cs_mes_fecha= 1'b1;
		cs_jahr_fecha= 1'b1;
		cs_seg_timer= 1'b0;
		cs_min_timer= 1'b0;
		cs_hora_timer= 1'b0;
			end
		2'b11:
			begin
		cs_seg_hora = 1'b0;
		cs_min_hora= 1'b0;
		cs_hora_hora= 1'b0;
		cs_dia_fecha= 1'b0;
		cs_mes_fecha= 1'b0;
		cs_jahr_fecha= 1'b0;
		cs_seg_timer= 1'b1;
		cs_min_timer= 1'b1;
		cs_hora_timer= 1'b1;
	end
	default: begin
		cs_seg_hora = 1'b0;
		cs_min_hora= 1'b0;
		cs_hora_hora= 1'b0;
		cs_dia_fecha= 1'b0;
		cs_mes_fecha= 1'b0;
		cs_jahr_fecha= 1'b0;
		cs_seg_timer= 1'b0;
		cs_min_timer= 1'b0;
		cs_hora_timer= 1'b0;
	end
endcase
end

endmodule