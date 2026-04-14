module top_module(
		
		input wire clock_i,

		
		output wire [7:0] D,
		
		
		input [7:0] l_rom,
		input l_rom_e,
		
		
		input [7:0] u_rom,
		input u_rom_e,

		
		input [7:0] ram,
		input ram_e,

		
		input [7:0] eram,
		input u_ram_e,
		
		
		input [7:0] pio8255,
		input pio8255_e,
		
		
		input [7:0] io,
		input io_e,
		
		
		input [7:0] fdc,
		input fdc_e
	);assign D =	(l_rom_e) ? l_rom :
					(u_rom_e) ? u_rom :
					(u_ram_e) ? eram :
					(ram_e) ? ram :
					(pio8255_e) ? pio8255 :
					(io_e) ? io :
					(fdc_e) ? fdc :
					8'd255;
endmodule