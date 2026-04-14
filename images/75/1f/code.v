module top_module(
pixel_clock,
reset,
vga_red_data,
vga_green_data,
vga_blue_data,
h_synch,
v_synch,
blank,

VGA_HSYNCH,
VGA_VSYNCH,
VGA_OUT_RED,
VGA_OUT_GREEN,
VGA_OUT_BLUE
);input				pixel_clock;
input				reset;
input				vga_red_data;
input				vga_green_data;
input				vga_blue_data;
input				h_synch;
input				v_synch;
input				blank;

output			VGA_HSYNCH;
output			VGA_VSYNCH;
output			VGA_OUT_RED;
output			VGA_OUT_GREEN;
output			VGA_OUT_BLUE;

reg				VGA_HSYNCH;
reg				VGA_VSYNCH;
reg				VGA_OUT_RED;
reg				VGA_OUT_GREEN;
reg				VGA_OUT_BLUE;


always @ (posedge pixel_clock or posedge reset) begin
	if (reset) begin
		
		VGA_HSYNCH 				<= 1'b1;
		VGA_VSYNCH 				<= 1'b1;
		VGA_OUT_RED				<= 1'b0;
		VGA_OUT_GREEN			<= 1'b0;
		VGA_OUT_BLUE			<= 1'b0;
	end
	
	else if (blank) begin
		
		VGA_HSYNCH	 			<= h_synch;
		VGA_VSYNCH 	 			<= v_synch;
		VGA_OUT_RED				<= 1'b0;
		VGA_OUT_GREEN			<= 1'b0;
		VGA_OUT_BLUE			<= 1'b0;
	end
	
	else begin
		
		VGA_HSYNCH	 			<= h_synch;
		VGA_VSYNCH 	 			<= v_synch;
		VGA_OUT_RED				<= vga_red_data;
		VGA_OUT_GREEN			<= vga_green_data;
		VGA_OUT_BLUE			<= vga_blue_data;
	end
end

endmodule