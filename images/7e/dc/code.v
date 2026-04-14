module top_module(input wire [1:0] clkvec,output reg [1:0] count);genvar igen; 
  generate 
  for (igen=0; igen<2; igen=igen+1) begin : code_gen 
  wire clk_tmp = clkvec[igen]; 
  initial count[igen] = 1'b0; 
  always @ (posedge clk_tmp) 
  count[igen] <= count[igen] + 1; 
  end 
  endgenerate 
 endmodule