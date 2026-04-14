module top_module(clk, data, enable, initialize, crc);parameter Tp = 1; 
 input clk; 
 input data; 
 input enable; 
 input initialize; 
 output [14:0] crc; 
 reg [14:0] crc; 
 wire crc_next; 
 wire [14:0] crc_tmp; 
 assign crc_next = data ^ crc[14]; 
 assign crc_tmp = {crc[13:0], 1'b0}; 
 always @ (posedge clk) 
 begin 
  if(initialize) 
  crc <= #Tp 15'h0; 
  else if (enable) 
  begin 
  if (crc_next) 
  crc <= #Tp crc_tmp ^ 15'h4599; 
  else 
  crc <= #Tp crc_tmp; 
  end 
 end 
 endmodule