module top_module(out,
    \GEN_LITE_IS_ASYNC.GEN_ASYNC_LITE_ACCESS.s2mm_ip2axi_rddata_d1_reg[31] );output [31:0]out;
  input [31:0]\GEN_LITE_IS_ASYNC.GEN_ASYNC_LITE_ACCESS.s2mm_ip2axi_rddata_d1_reg[31] ;

  (* DONT_TOUCH *) wire [31:0]ip2axi_rddata_int;

  assign ip2axi_rddata_int = \GEN_LITE_IS_ASYNC.GEN_ASYNC_LITE_ACCESS.s2mm_ip2axi_rddata_d1_reg[31] [31:0];
  assign out[31:0] = ip2axi_rddata_int;endmodule