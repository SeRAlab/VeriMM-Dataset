module top_module(
    input [7:0] entrada,
    output reg [3:0] unidad, decena, centena
    );always @*
	begin
		centena = (entrada / 256);
		decena = ((entrada % 256) / 16);
		unidad = (entrada % 16);
	end

endmodule