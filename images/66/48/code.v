module top_module(input wire clk, reset, vgae,input wire [15:0] e,output wire [7:0] vgax, vgay,output wire vgaw);integer i; 
  initial begin 
  for (i=0; i<10; i=i+1) begin 
  i=i; 
  end 
  end 
  assign vgax = 8'b00000000; 
  assign vgay = 8'b00000000; 
  assign vgaw = 1; 
 endmodule