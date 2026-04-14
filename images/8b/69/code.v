module top_module(
out      ,  
data     ,  
load     ,  
enable   ,  
clk      ,  
reset       
);output [7:0] out;

input [7:0] data;
input load, enable, clk, reset;

reg [7:0] out;

always @(posedge clk)
if (reset) begin
  out <= 8'b0 ;
end else if (load) begin
  out <= data;
end else if (enable) begin
  out <= out + 1;
end
    
endmodule