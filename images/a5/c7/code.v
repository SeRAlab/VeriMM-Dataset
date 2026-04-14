module top_module(
	input  wire			clk,
	input  wire	[7:0]	char,
	input  wire	[3:0]	row,
	output reg	[11:0]	data_row
);(* ram_init_file = "vga_term/vga_font.mif" *)
	(* ram_style = "distributed" *)
	reg [11:0] ram[256*16-1:0];
	
	wire [11:0] addr = {char, row};
	always @(posedge clk) data_row <= ram[addr];endmodule