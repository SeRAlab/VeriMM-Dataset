module top_module(input wire sysclock,input wire [31:0] inputMulA,output reg [63:0] product);initial begin 
  product <= 64'd0; 
 end 
 always @ (posedge sysclock) begin 
  product <= (inputMulA * inputMulA); 
 end 
 endmodule