module top_module(input clk,
                 output reg vga_h, output reg vga_v,
                 output reg [3:0] vga_r, output reg[3:0] vga_g, output reg[3:0] vga_b,
                 output [9:0] vga_hcounter,
                 output [9:0] vga_vcounter,
                 output [9:0] next_pixel_x, 
                 input [14:0] pixel,        
                 input sync,
                 input border);reg [9:0] h, v;
wire hpicture = (h < 512);                    
wire hsync_on = (h == 512 + 23 + 35);         
wire hsync_off = (h == 512 + 23 + 35 + 82);   
wire hend = (h == 681);                       

wire vpicture = (v < 480);                    
wire vsync_on  = hsync_on && (v == 480 + 10); 
wire vsync_off = hsync_on && (v == 480 + 12); 
wire vend = (v == 523);                       
wire inpicture = hpicture && vpicture;
assign vga_hcounter = h;
assign vga_vcounter = v;
wire [9:0] new_h = (hend || sync) ? 0 : h + 1;
assign next_pixel_x = {sync ? 1'b0 : hend ? !v[0] : v[0], new_h[8:0]};

always @(posedge clk) begin
  h <= new_h;
  if (sync) begin
    vga_v <= 1;
    vga_h <= 1;
    v <= 0;
  end else begin
    vga_h <= hsync_on ? 0 : hsync_off ? 1 : vga_h;
    if (hend)
      v <= vend ? 0 : v + 1;
    vga_v <= vsync_on ? 0 : vsync_off ? 1 : vga_v;
    vga_r <= pixel[4:1];
    vga_g <= pixel[9:6];
    vga_b <= pixel[14:11];
    if (border && (h == 0 || h == 511 || v == 0 || v == 479)) begin
      vga_r <= 4'b1111;
      vga_g <= 4'b1111;
      vga_b <= 4'b1111;
    end
    if (!inpicture) begin
      vga_r <= 4'b0000;
      vga_g <= 4'b0000;
      vga_b <= 4'b0000;
    end
  end
end
endmodule