module top_module(
		input wire clk_disp, rst,
		input wire Disp_Enable,
		input wire [7:0] Unidades,
		input wire [7:0] Decenas,
		input wire [7:0] Estado,
		output reg [7:0] Anodo,
		output wire [3:0] Seleccion,
		output wire Catodo
    );reg [3:0]i_actual, i_siguiente;
reg [7:0] anodo;

always@(posedge clk_disp, posedge rst)
begin	



	if(rst)
	begin
		i_actual<=4'b0001;
		Anodo <= 8'h00;
	end
	else
	begin
		i_actual <= Disp_Enable ? i_siguiente : 4'h0;
		Anodo <= anodo;
	end
end

always@*
begin
	anodo = 8'h00;
	i_siguiente= 4'b0000;
	case(i_actual)
		4'b0001:
		begin
			anodo = Unidades;
			i_siguiente = 4'b0010;
		end		
		4'b0010:
		begin		
			anodo = Decenas;
			i_siguiente = 4'b1000;
		end		
		4'b1000:
			anodo = Estado;
		default: i_siguiente = 4'b0001;
	endcase
end

assign Seleccion=i_actual;endmodule