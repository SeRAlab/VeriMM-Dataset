module memory_to_color(color_depth_i, mem_i, mem_lsb_i,
                       color_o, sel_o);
input  [1:0]  color_depth_i;
input  [31:0] mem_i;
input  [1:0]  mem_lsb_i;
output [31:0] color_o;
output [3:0]  sel_o;
assign sel_o = color_depth_i == 2'b00 ? 4'b0001 : 
               color_depth_i == 2'b01 ? 4'b0011 : 
               4'b1111; 
assign color_o = (color_depth_i == 2'b00) && (mem_lsb_i == 2'b00) ? {mem_i[31:24]} : 
                 (color_depth_i == 2'b00) && (mem_lsb_i == 2'b01) ? {mem_i[23:16]} : 
                 (color_depth_i == 2'b00) && (mem_lsb_i == 2'b10) ? {mem_i[15:8]}  : 
                 (color_depth_i == 2'b00) && (mem_lsb_i == 2'b11) ? {mem_i[7:0]}   : 
                 (color_depth_i == 2'b01) && (mem_lsb_i[0] == 1'b0)  ? {mem_i[31:16]} : 
                 (color_depth_i == 2'b01) && (mem_lsb_i[0] == 1'b1)  ? {mem_i[15:0]}  : 
                 mem_i; 
endmodule