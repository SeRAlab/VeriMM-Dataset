module top_module(rom_address,rom_data);input [ 4: 0] rom_address; 
 output [23: 0] rom_data; 
 reg [23: 0] data; 
 assign rom_data = {data[13: 8], 2'h0, 
  data[ 7: 0]}; 
 always @(*) 
 begin 
  case (rom_address) 
  0 : data <= {6'h02, 8'h07}; 
  1 : data <= {6'h03, 8'hDF}; 
  2 : data <= {6'h04, 8'h17}; 
  3 : data <= {6'h11, 8'h00}; 
  4 : data <= {6'h12, 8'h5B}; 
  5 : data <= {6'h13, 8'hFF}; 
  6 : data <= {6'h14, 8'h00}; 
  7 : data <= {6'h15, 8'h20}; 
  8 : data <= {6'h16, 8'h40}; 
  9 : data <= {6'h17, 8'h80}; 
  10 : data <= {6'h18, 8'h00}; 
  11 : data <= {6'h19, 8'h80}; 
  12 : data <= {6'h1A, 8'h00}; 
  13 : data <= {6'h1B, 8'h00}; 
  14 : data <= {6'h1C, 8'h80}; 
  15 : data <= {6'h1D, 8'hC0}; 
  16 : data <= {6'h1E, 8'hE0}; 
  17 : data <= {6'h1F, 8'hFF}; 
  18 : data <= {6'h20, 8'hD2}; 
  19 : data <= {6'h21, 8'hD2}; 
  default : data <= 14'h0000; 
  endcase 
 end 
 endmodule