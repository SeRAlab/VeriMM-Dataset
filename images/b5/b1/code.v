module top_module(input clk,output reg hsync,output reg vsync,output reg[9:0] pixh,output reg[9:0] pixv);localparam SYNC_ON = 1'b0; 
 localparam SYNC_OFF = 1'b1; 
 reg[9:0] line_count = 0; 
 reg[9:0] pix_count = 0; 
 always @( posedge clk) 
 begin 
  pix_count <= pix_count + 1; 
  case (pix_count) 
  0: hsync <= SYNC_OFF; 
  16: hsync <= SYNC_ON; 
  112: hsync <= SYNC_OFF; 
  800: begin 
  line_count <= line_count + 1; 
  pix_count <= 0; 
  end 
  endcase 
  case (line_count) 
  0: vsync <= SYNC_OFF; 
  10: vsync <= SYNC_ON; 
  12: vsync <= SYNC_OFF; 
  525: begin 
  line_count <= 0; 
  end 
  endcase 
  pixh <= 0; 
  pixv <= 0; 
  if (line_count>=35 && line_count<515) 
  begin 
  if (pix_count>=160 && pix_count<800) 
  begin 
  pixh <= pix_count - 10'd160; 
  pixv <= line_count - 10'd35; 
  end 
  end 
 end 
 endmodule