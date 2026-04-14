module top_module(
		input wire [7:0] dato, 
		input wire EN,
		input wire clk,
		input wire rst,
		output reg [7:0] dato_out 
    );always @ (posedge clk, posedge rst)
	if (rst)
		dato_out <= 8'b0;
	else if (EN)
		dato_out <= dato;

endmodule