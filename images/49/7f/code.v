module top_module(input clkA,input FlagIn_clkA,input clkB,output FlagOut_clkB,input rst_n);reg FlagToggle_clkA = 1'b0; 
  always @(posedge clkA or negedge rst_n) 
  if (rst_n == 1'b0) begin 
  FlagToggle_clkA <= 1'b0; 
  end else begin 
  FlagToggle_clkA <= FlagToggle_clkA ^ FlagIn_clkA; 
  end 
  reg [2:0] SyncA_clkB = 3'b0; 
  always @(posedge clkB or negedge rst_n) 
  if (rst_n == 1'b0) begin 
  SyncA_clkB <= 3'b0; 
  end else begin 
  SyncA_clkB <= {SyncA_clkB[1:0], FlagToggle_clkA}; 
  end 
  assign FlagOut_clkB = (SyncA_clkB[2] ^ SyncA_clkB[1]); 
 endmodule