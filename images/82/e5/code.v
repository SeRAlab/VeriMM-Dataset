module top_module(Seleccion,D1,D0,Y);input wire Seleccion;
input wire [3:0] D1,D0;
output reg [3:0] Y;

always @* 

begin

case(Seleccion)

1'b0: Y <= D0;
1'b1: Y <= D1;

endcase 

end

endmodule