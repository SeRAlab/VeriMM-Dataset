module top_module(input clk, input ce,
                        input enabled,          
                        input obj_size,         
                        input obj_patt,         
                        input [2:0] cycle,      
                        input [7:0] temp,       
                        output [12:0] vram_addr,
                        input [7:0] vram_data,  
                        output [3:0] load,      
                        output [26:0] load_in);reg [7:0] temp_tile;    
  reg [3:0] temp_y;       
  reg flip_x, flip_y;     
  wire load_y =    (cycle == 0);
  wire load_tile = (cycle == 1);
  wire load_attr = (cycle == 2) && enabled;
  wire load_x =    (cycle == 3) && enabled;
  wire load_pix1 = (cycle == 5) && enabled;
  wire load_pix2 = (cycle == 7) && enabled;
  reg dummy_sprite; 
  
  wire [7:0] vram_f = dummy_sprite ? 0 : 
                      !flip_x ?      {vram_data[0], vram_data[1], vram_data[2], vram_data[3], vram_data[4], vram_data[5], vram_data[6], vram_data[7]} : 
                                     vram_data;
  wire [3:0] y_f = temp_y ^ {flip_y, flip_y, flip_y, flip_y};
  assign load = {load_pix1, load_pix2, load_x, load_attr};
  assign load_in = {vram_f, vram_f, temp, temp[1:0], temp[5]};
  
  
  
  
  
  
  assign vram_addr = {obj_size ? temp_tile[0] : obj_patt, 
                      temp_tile[7:1], obj_size ? y_f[3] : temp_tile[0], cycle[1], y_f[2:0] };
  always @(posedge clk) if (ce) begin
    if (load_y) temp_y <= temp[3:0];
    if (load_tile) temp_tile <= temp;
    if (load_attr) {flip_y, flip_x, dummy_sprite} <= {temp[7:6], temp[4]};
  end









endmodule