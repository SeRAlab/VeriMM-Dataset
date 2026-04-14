module top_module(
  input [2:0] data,
  output [1:0] count
);assign count = {~&data[2:1], ~&data[1:0]};
  
endmodule