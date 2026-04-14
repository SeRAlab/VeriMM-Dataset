module top_module(input wire data_in_0,
   input wire data_in_1,
   input wire select,
   output wire data_out);assign data_out = select ? data_in_1 : data_in_0;

endmodule