module top_module(data,rdaddress,wraddress,wren, clock,q);parameter DATA_WIDTH=36; 
 parameter ADDR_WIDTH=8; 
 input [(DATA_WIDTH-1):0] data; 
 input [(ADDR_WIDTH-1):0] rdaddress, wraddress; 
 input wren, clock; 
 output reg [(DATA_WIDTH-1):0] q; 
  reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0]; 
  always @ (posedge clock) 
  begin 
  if (wren) 
  ram[wraddress] <= data[DATA_WIDTH-1:0]; 
  q <= ram[rdaddress]; 
  end 
 endmodule