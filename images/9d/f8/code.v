module top_module(grant, await,request);parameter ARW=99; 
  input [ARW-1:0] request; 
  output [ARW-1:0] grant; 
  output [ARW-1:0] await; 
  genvar j; 
  assign await[0] = 1'b0; 
  generate for (j=ARW-1; j>=1; j=j-1) begin : gen_arbiter 
  assign await[j] = |request[j-1:0]; 
  end 
  endgenerate 
  assign grant[ARW-1:0] = request[ARW-1:0] & ~await[ARW-1:0]; 
 endmodule