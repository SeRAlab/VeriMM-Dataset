module top_module(input wire [15:0] immediate,output reg [31:0] extended);always @(immediate) begin 
  extended[31:0] = {{16{immediate[15]}}, immediate[15:0]}; 
  end 
 endmodule