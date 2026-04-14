module top_module(
      input wire a,           
      input wire b,
      input wire c,
      output wire led         
    );assign 	led = ~((a&b)|(b&c)|(a&c));   
  endmodule