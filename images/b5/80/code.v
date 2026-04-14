module top_module(tile_count, all_tiles_counted, clock, reset, enable);output reg [3:0] tile_count;
	output all_tiles_counted;
	
	input clock, reset, enable;
	
	always @(posedge clock, posedge reset)
		begin
			if (reset)
				begin
					tile_count <= 0;
				end
			
			else if (enable)
				if (tile_count == 4'd10)
						tile_count <= 0;
				else
						tile_count <= tile_count + 4'd1;
		end
	
	assign all_tiles_counted = (tile_count == 0) ? 1'd1 : 1'd0;endmodule