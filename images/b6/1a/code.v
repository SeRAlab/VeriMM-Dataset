module top_module(
	 input wire rst,
    input wire [7:0] decenas,
    input wire [7:0] unidades,
    input wire [7:0] presencia,
    input wire [7:0] ignicion,
    output reg [4:0] Temp,
    output reg Pres,
    output reg Carro
    );reg [4:0] unidades_Decimal;

always @ *
	if(rst)
		begin
		Temp = 5'b0;
		Pres = 0;
		Carro =0;
		end
	else
		begin
		unidades_Decimal = (unidades ==8'h16)? 5'd1:
								 (unidades ==8'h1E)? 5'd2:
								 (unidades ==8'h26)? 5'd3:
								 (unidades ==8'h25)? 5'd4:
								 (unidades ==8'h2E)? 5'd5:
								 (unidades ==8'h36)? 5'd6:
								 (unidades ==8'h3D)? 5'd7:
								 (unidades ==8'h3E)? 5'd8:
								 (unidades ==8'h46)? 5'd9: 5'd0;
								 
		Pres = (presencia==8'h4D)? 1'b1:1'b0;
		Carro = (ignicion == 8'h43)? 1'b1 :1'b0;
		Temp = (decenas >= 8'h2E)? (unidades_Decimal+5'b11110):
				 (decenas == 8'h25)? (unidades_Decimal+5'b10100):
				 (decenas == 8'h26)? (unidades_Decimal+5'b01010): unidades_Decimal;
		end
endmodule