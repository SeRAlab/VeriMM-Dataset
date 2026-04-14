module top_module(output reg result, input branch, condition);always @*
  result = branch & condition;endmodule