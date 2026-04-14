module top_module(
   input  [2:0] SW,
   output [1:0] LED
   );assign LED[0] = ((SW[0]&SW[0])|(~((~SW[1])|(~SW[2]))))&(~(SW[1]&SW[2]));
   assign LED[1] = SW[0] && SW[1] && !SW[2];
endmodule