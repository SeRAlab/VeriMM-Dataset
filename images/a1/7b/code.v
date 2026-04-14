module top_module(input wire sysclock,input wire [4:0] address,input wire [7:0] datain,output reg [7:0] dataout,input wire write_enable);reg [7:0] mem [0:31]; 
 initial begin 
  dataout <= 8'd0; 
 end 
 always @ (posedge sysclock) begin 
  if (write_enable) begin 
  mem[address] <= datain; 
  end 
  else begin 
  dataout <= mem[address]; 
  end 
 end 
 endmodule