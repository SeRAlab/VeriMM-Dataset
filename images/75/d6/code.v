module top_module(input clk,input rdclk,input [7:0] data,input acapture,output reg write,output reg [15:0] wrdata,output reg [9:0] horiz_count);reg uphalf; 
 reg [7:0] upbyte; 
 reg loaded; 
 always @(posedge clk) 
 begin 
  if (write) begin 
  write <= 1'b0; 
  end 
  if (!acapture) begin 
  uphalf <= 1'b1; 
  loaded <= 1'b0; 
  write <= 1'b0; 
  horiz_count<= 0; 
  end else begin 
  if (rdclk) begin 
  if (!loaded) begin 
  if (uphalf) begin 
  upbyte <= data; 
  uphalf <= 1'b0; 
  loaded <= 1'b1; 
  end else begin 
  horiz_count <= horiz_count + 1'b1; 
  wrdata <= {upbyte, data}; 
  uphalf <= 1'b1; 
  write <= 1'b1; 
  loaded <= 1'b1; 
  end 
  end 
  end else begin 
  loaded <= 1'b0; 
  end 
  end 
 end 
 endmodule