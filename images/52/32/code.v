module top_module(clock,dac_clock,dac_leftright,dac_data,load,datain);input clock; 
  output dac_clock; 
  output dac_leftright; 
  output dac_data; 
  output reg load; 
  input [15:0] datain; 
  reg [16:0] data; 
  reg [2:0] fifth; 
  reg [6:0] sync; 
  wire load_int; 
  initial 
  begin 
  fifth <= 0; 
  sync <= 0; 
  data <= 0; 
  load <= 0; 
  end 
  always @(posedge clock) 
  begin 
  if( fifth[2] ) 
  fifth <= 3'b000; 
  else 
  fifth <= fifth + 3'd1; 
  end 
  always @(posedge clock) 
  begin 
  if( fifth[2] ) sync <= sync + 7'd1; 
  end 
  assign load_int = fifth[2] & (&sync[5:0]); 
  always @(posedge clock) 
  begin 
  load <= load_int; 
  end 
  always @(posedge clock) 
  begin 
  if( fifth[2] && sync[0] ) 
  begin 
  if( load_int ) 
  data[15:0] <= datain; 
  else 
  data[15:0] <= { data[14:0], 1'b0 }; 
  data[16] <= data[15]; 
  end 
  end 
  assign dac_leftright = sync[6]; 
  assign dac_clock = sync[0]; 
  assign dac_data = data[16]; 
 endmodule