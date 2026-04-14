module top_module(
	sector,
	flash_sector
);parameter SECTOR1_MAP = 1;
	parameter SECTOR2_MAP = 1;
	parameter SECTOR3_MAP = 1;
	parameter SECTOR4_MAP = 1;
	parameter SECTOR5_MAP = 1;

	input [2:0] sector;
	output [2:0] flash_sector;

	assign flash_sector = 
		(sector == 1) ? SECTOR1_MAP[2:0] :
		(sector == 2) ? SECTOR2_MAP[2:0] :
		(sector == 3) ? SECTOR3_MAP[2:0] :
		(sector == 4) ? SECTOR4_MAP[2:0] :
		(sector == 5) ? SECTOR5_MAP[2:0] :
		3'd0; 

endmodule