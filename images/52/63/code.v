module top_module(out,
    in0);output [31:0]out;
  input [31:0]in0;

  (* DONT_TOUCH *) wire [31:0]ip2axi_rddata_int;

  assign ip2axi_rddata_int = in0[31:0];
  assign out[31:0] = ip2axi_rddata_int;endmodule