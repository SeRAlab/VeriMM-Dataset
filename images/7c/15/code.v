module top_module(input logic [31:0]a,b,
              output logic [31:0] res,
              output logic zero);assign res = a-b;
  assign zero = ~|res;endmodule