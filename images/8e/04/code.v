module top_module(
  input  [63:0] io_ins_0_addr,
  input         io_ins_0_isWr,
  input  [15:0] io_ins_0_size,
  output [63:0] io_out_addr,
  output        io_out_isWr,
  output [15:0] io_out_size
);assign io_out_addr = io_ins_0_addr;
  assign io_out_isWr = io_ins_0_isWr;
  assign io_out_size = io_ins_0_size;
endmodule