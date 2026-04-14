module top_module(
    input Pixel_clock,
	 input R_input,
	 input G_input,
	 input B_input,
	 input change_color,
    output reg red_reg=1'b0,
    output reg green_reg=1'b0,
    output reg blue_reg=1'b0
    );always@(posedge Pixel_clock)
begin
	 if(change_color)
	 begin
	     red_reg<=R_input;
		  green_reg<=G_input;
		  blue_reg<=B_input;
	 end
	 else
	 begin
	     red_reg<=red_reg;
		  green_reg<=green_reg;
		  blue_reg<=blue_reg;
	 end
end


endmodule