module top_module(output wire out, input wire in);reg rval = 0;
  assign out = rval;
  always @(posedge in) rval = rval + 1;
endmodule