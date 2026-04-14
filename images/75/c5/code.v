module top_module(input I, OE, output O);wire O_temp;

  assign O_temp = OE ? I : O;

  assign O = O_temp;

endmodule