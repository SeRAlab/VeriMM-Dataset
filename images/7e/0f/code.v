module top_module( input pxl_clk,
            input reset_n,
            output reg [9:0] hcount,
            output reg [9:0] vcount,
            output reg vsync,
            output reg hsync );always @ (posedge pxl_clk or negedge reset_n)
    begin : hcounter
        if (!reset_n) hcount <= 0;
        
        else if (hcount <= 799) hcount <= hcount + 1'b1;
        
        else hcount <= 0;
    end
    
    always @ (posedge pxl_clk or negedge reset_n)
    begin : vcounter
        if (!reset_n) vcount <= 0;
        
        else if (hcount == 799 && vcount <= 521) vcount <= vcount + 1'b1;
        
        else if (vcount <= 521) vcount <= vcount;
        
        else vcount <= 0;
    end

    always @ (hcount)
    begin : hsync_decoder
        if (hcount >= 656 && hcount <= 752) hsync <= 0;
        
        else hsync <= 1;
        
    end
    
  
    always @ (vcount)
    begin : vsync_decoder
        if (vcount >= 482 && vcount <= 492) vsync <= 0;
        
        else vsync <= 1;
    end

endmodule