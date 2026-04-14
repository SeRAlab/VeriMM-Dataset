module top_module(input clk,input wire [3:0] addr,output reg [7:0] data);reg [7:0] rom [0:15]; 
  always @(negedge clk) begin 
  data <= rom[addr]; 
  end 
 initial begin 
  rom[0] = 8'hAA; 
  rom[1] = 8'h55; 
  rom[2] = 8'hAA; 
  rom[3] = 8'h55; 
  rom[4] = 8'h11; 
  rom[5] = 8'h22; 
  rom[6] = 8'h44; 
  rom[7] = 8'h88; 
  rom[8] = 8'h99; 
  rom[9] = 8'hCC; 
  rom[10] = 8'hFF; 
  rom[11] = 8'h08; 
  rom[12] = 8'h04; 
  rom[13] = 8'h02; 
  rom[14] = 8'h01; 
  rom[15] = 8'h00; 
  end 
 endmodule