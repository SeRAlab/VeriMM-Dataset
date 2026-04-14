module top_module(
  input clk,                
  input rst,
  output reg HS,            
  output reg VS,            
  output reg [10:0] countX, 
  output reg [9:0] countY   
);always @(posedge clk) begin
  if(rst) begin
    countX <= 0;
    countY <= 0;
    HS <= 1; 
    VS <= 1;
  end else begin
    if (countX == 1343) begin
      countX <= 0;
      if (countY == 805) countY <= 0;
      else countY <= countY + 1'b1;
    end else countX <= countX + 1'b1;
    if      (countX == 1047) HS <= 0; 
    else if (countX == 1143) HS <= 1; 
    if      (countY == 770) VS <= 0;  
    else if (countY == 772) VS <= 1;  
  end
end

endmodule