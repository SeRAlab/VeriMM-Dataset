module color_to_memory(color_depth_i, color_i, x_lsb_i,
                       mem_o, sel_o);
input  [1:0]  color_depth_i;
input  [31:0] color_i;
input  [1:0]  x_lsb_i;
output [31:0] mem_o;
output [3:0]  sel_o;
assign sel_o = (color_depth_i == 2'b00) && (x_lsb_i == 2'b00) ? 4'b1000 : 
               (color_depth_i == 2'b00) && (x_lsb_i == 2'b01) ? 4'b0100 : 
               (color_depth_i == 2'b00) && (x_lsb_i == 2'b10) ? 4'b0010 : 
               (color_depth_i == 2'b00) && (x_lsb_i == 2'b11) ? 4'b0001 : 
               (color_depth_i == 2'b01) && (x_lsb_i[0] == 1'b0)  ? 4'b1100  : 
               (color_depth_i == 2'b01) && (x_lsb_i[0] == 1'b1)  ? 4'b0011  : 
               4'b1111; 
assign mem_o = (color_depth_i == 2'b00) && (x_lsb_i == 2'b00) ? {color_i[7:0], 24'h000000} : 
               (color_depth_i == 2'b00) && (x_lsb_i == 2'b01) ? {color_i[7:0], 16'h0000}   : 
               (color_depth_i == 2'b00) && (x_lsb_i == 2'b10) ? {color_i[7:0], 8'h00}      : 
               (color_depth_i == 2'b00) && (x_lsb_i == 2'b11) ? {color_i[7:0]}             : 
               (color_depth_i == 2'b01) && (x_lsb_i[0] == 1'b0)  ? {color_i[15:0], 16'h0000}   : 
               (color_depth_i == 2'b01) && (x_lsb_i[0] == 1'b1)  ? {color_i[15:0]}             : 
               color_i; 
endmodule