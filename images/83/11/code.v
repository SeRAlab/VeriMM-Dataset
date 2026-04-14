module top_module(Seleccion,Dn,Y);input [3:0] Seleccion;
input [15:0] Dn;
output Y;

wire [3:0] Seleccion;
wire [15:0] Dn;
wire Y;

assign Y = Dn[Seleccion];


endmodule