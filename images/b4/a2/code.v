module top_module(pclk, prst, bs_stb, bs_we, bs_adr, bs_din, bs_dout);input pclk; 
  input prst; 
  input bs_stb; 
  input bs_we; 
  input [0:7] bs_adr; 
  input [0:15] bs_din; 
  output [0:15] bs_dout; 
  always @(posedge pclk) begin 
  if(bs_stb) begin 
 $display("%m Device %o Strobe! %h %b %b",bs_adr[0:5], bs_din, bs_adr[6:7], bs_we); 
  if(bs_we) begin 
  case(bs_adr[6:7]) 
  2'b00: 
  begin 
  case(bs_din[14:15]) 
  2'b00: 
  $display("%m Spurious Update"); 
  2'b01: 
  $display("%m Start"); 
  2'b10: 
  $display("%m Clear"); 
  2'b11: 
  $display("%m Pulse"); 
  endcase 
  end 
  2'b01: 
  $display("%m DOA %h", bs_din); 
  2'b10: 
  $display("%m DOB %h", bs_din); 
  2'b11: 
  $display("%m DOC %h", bs_din); 
  endcase 
  end 
  else begin 
  case(bs_adr[6:7]) 
  2'b00: 
  $display("%m Flag Read"); 
  2'b01: 
  $display("%m DIA"); 
  2'b10: 
  $display("%m DIB"); 
  2'b11: 
  $display("%m DIC"); 
  endcase 
  end 
  end 
  end 
 endmodule