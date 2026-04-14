module top_module(d_i, vsync_i, href_i, pclk_i, rst_i, pixelReady_o, pixel_o);input       [7:0] d_i;        
   input       vsync_i;          
   input       href_i;           
   input       pclk_i;           
   input       rst_i;            
   output reg  pixelReady_o;     
   output reg  [15:0] pixel_o;   
   
   
   reg         odd = 0;
   reg         frameValid = 0;

   always @(posedge pclk_i) begin
      pixelReady_o <= 0;
      if (rst_i == 0) begin
         odd <= 0;
         frameValid <= 0;
      end else begin
         if (frameValid == 1 && vsync_i == 0 && href_i == 1) begin
            if (odd == 0) begin    
               pixel_o[15:8] <= d_i;
            end else begin
               pixel_o[7:0] <= d_i;
               pixelReady_o <= 1;   
            end
            odd <= ~odd;
         
         end else if (frameValid == 0 && vsync_i == 1) begin
            frameValid <= 1;            
         end
      end
   end
   
endmodule