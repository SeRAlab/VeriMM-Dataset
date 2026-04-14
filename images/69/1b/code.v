module top_module(
	input		de_clk,		
	input		clamp_x,	
	input		clamp_y,	
	input	[10:0]	x,		
	input	[10:0]	y,		
	input	[10:0]	clamp_mask_x,	
	input	[10:0]	clamp_mask_y,	
	input	[8:0]	bitmask_x,	
	input	[8:0]	bitmask_y,	

	output reg		clamp,		
	output reg	[8:0]	new_x,		
	output reg	[8:0]	new_y,		
	output reg	[8:0]	new_x_d,	
	output reg	[8:0]	new_y_d		
	);reg		clamp_d;

wire		outside_x,	
		outside_y;	


assign outside_x = |(x & clamp_mask_x);
assign outside_y = |(y & clamp_mask_y);

always @(posedge de_clk) begin
	clamp <= clamp_d;
	clamp_d <= outside_x & clamp_x | outside_y & clamp_y;
	new_x <= new_x_d;
	new_y <= new_y_d;
end

always @(posedge de_clk) begin
  casex ({clamp_x, outside_x, x[10]}) 
    3'b0xx,3'b10x: 	new_x_d <= x[8:0] & bitmask_x; 	
    3'b110: 		new_x_d <= bitmask_x;		
    3'b111: 		new_x_d <= 0;			
  endcase
end

always @(posedge de_clk) begin
  casex ({clamp_y, outside_y, y[10]}) 
    3'b0xx, 3'b10x: 	new_y_d <= y[8:0] & bitmask_y; 	
    3'b110: 		new_y_d <= bitmask_y;		
    3'b111: 		new_y_d <= 0;			
  endcase
end

endmodule