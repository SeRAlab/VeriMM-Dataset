module top_module(input [15:0] x,input [15:0] y,input zx, nx, zy, ny, f, no,output [15:0] out,output zr,output ng);reg [15:0] r_x_a; 
  reg [15:0] r_x; 
  reg [15:0] r_y_a; 
  reg [15:0] r_y; 
  reg [15:0] r_out = 16'b0; 
  reg r_zr; 
  reg r_ng; 
  always @ (*) begin 
  if (zx == 1) begin 
  r_x_a = 16'b0; 
  end else begin 
  r_x_a = x; 
  end 
  if (nx == 1) begin 
  r_x = ~r_x_a; 
  end else begin 
  r_x = r_x_a; 
  end 
  if (zy) begin 
  r_y_a = 1'b0; 
  end else begin 
  r_y_a = y; 
  end 
  if (ny == 1) begin 
  r_y = ~r_y_a; 
  end else begin 
  r_y = r_y_a; 
  end 
  if (f == 1) begin 
  r_out = r_x + r_y; 
  end else begin 
  r_out = r_x & r_y; 
  end 
  if (no == 1) begin 
  r_out = ~r_out; 
  end else begin 
  r_out = r_out; 
  end 
  if (r_out == 0) begin 
  r_zr = 1'b1; 
  end else begin 
  r_zr = 1'b0; 
  end 
  if (r_out[15] == 1) begin 
  r_ng = 1'b1; 
  end else begin 
  r_ng = 1'b0; 
  end 
  end 
  assign out = r_out; 
  assign zr = r_zr; 
  assign ng = r_ng; 
 endmodule