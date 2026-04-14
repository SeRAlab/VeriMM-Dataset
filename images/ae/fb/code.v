module top_module(input vga_clk, output hsync, output blank, output line_clk, output [11:0] column);parameter h_res = 1024;
   parameter h_front_porch = 48;
   parameter h_sync = 96;
   parameter h_back_porch = 208;
   parameter h_total = h_res + h_front_porch + h_sync + h_back_porch;

   reg [12:0] hcount = 0;
   reg line_clk_state = 0;
   reg [11:0] column_count = 0;
   
   always @ (posedge vga_clk) begin
     $monitor("%0t %m, hcount=%d, hsync=%b, blank=%b, column_count=%d", $time, hcount, hsync, blank, column_count);
     if(hcount < h_total) begin
       hcount <= hcount + 1'b1;
       line_clk_state <= 0;
     end else begin 
       hcount <= 0;
       line_clk_state <= 1;
     end    
     column_count <= blank ? 12'b0 : column_count + 1'b1;
   end
   
   assign hsync = !(hcount > (h_res + h_front_porch) && hcount <= (h_res + h_front_porch + h_sync));
   assign line_clk = line_clk_state;
   assign blank = hcount > h_res;
   assign column = column_count;endmodule