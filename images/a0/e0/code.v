module top_module(input_num, twos_comp);input [3:0] input_num;
   output [3:0] twos_comp;

   assign twos_comp = ~input_num + 1;

endmodule