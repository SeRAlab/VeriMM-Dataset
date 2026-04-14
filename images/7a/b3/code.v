module top_module(input in, output out);wire nand_out;
  assign nand_out = ~(in & in);
  assign out = nand_out;
endmodule