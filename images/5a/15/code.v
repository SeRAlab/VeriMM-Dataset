module top_module(input vga_clock,
            output reg [10:0] hcount = 0,    
            output reg [9:0] vcount = 0,	 
            output vsync, hsync, at_display_area);always @(posedge vga_clock) begin
        if (hcount == 1343) begin
            hcount <= 0;
        end
        else begin
            hcount <= hcount +  1;
        end
        if (vcount == 805) begin
            vcount <= 0;
        end
        else if(hcount == 1343) begin
            vcount <= vcount + 1;
        end
    end
    
    assign hsync = (hcount < 1047 || hcount >= 1183);
    assign vsync = (vcount < 776 || vcount >= 782);
    assign at_display_area = (hcount < 1023 && vcount < 767);endmodule