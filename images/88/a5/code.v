module top_module(pclk, bs_rst, bs_stb, bs_we, bs_adr, bs_din, bs_dout);input pclk; 
  input bs_rst; 
  input bs_stb; 
  input bs_we; 
  input [0:7] bs_adr; 
  input [0:15] bs_din; 
  output reg [0:15] bs_dout; 
  parameter device_addr = 6'o00; 
  reg r_DONE; 
  reg r_BUSY; 
  always @(posedge pclk) begin 
  if(bs_rst) begin 
  bs_dout <= 16'hzzzz; 
  r_DONE <= 1'b1; 
  r_BUSY <= 1'b0; 
  end 
  else begin 
  if(bs_stb & bs_adr[0:5] == device_addr) begin 
  if(bs_we) begin 
  case(bs_adr[6:7]) 
  2'b00: 
  begin 
  case(bs_din[14:15]) 
  2'b01: 
  begin 
  r_DONE <= 1'b0; 
  r_BUSY <= 1'b1; 
  end 
  2'b10: 
  begin 
  r_DONE <= 1'b0; 
  r_BUSY <= 1'b0; 
  end 
  2'b11: 
  begin 
  end 
  endcase 
  end 
  2'b01: 
  $display("DOA"); 
  2'b10: 
  $display("DOB"); 
  2'b11: 
  $display("DOC"); 
  endcase 
  end 
  else begin 
  case(bs_adr[6:7]) 
  2'b00: 
  bs_dout <= {r_BUSY, r_DONE, 14'h0000}; 
  2'b01: 
  $display("%m DIA"); 
  2'b10: 
  $display("%m DIB"); 
  2'b11: 
  $display("%m DIC"); 
  endcase 
  end 
  end 
  else 
  bs_dout <= 16'hzzzz; 
  end 
  end 
 endmodule