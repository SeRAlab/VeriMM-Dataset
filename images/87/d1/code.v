module top_module(
  input [4:0] rt_addr_IDEX,
  input [4:0] rs_addr_IDEX,
  input [4:0] rd_addr_EXMEM,
  input [4:0] rd_addr_MEMWB,
  input regwrite_EXMEM,
  input regwrite_MEMWB,
  output [1:0] forwardA,
  output [1:0] forwardB
);wire rs_from_mem, rt_from_mem, rs_from_ex, rt_from_ex;

  // Check for forwarding from memory stage
  assign rs_from_mem = (rd_addr_MEMWB == rs_addr_IDEX) && (regwrite_MEMWB == 1);
  assign rt_from_mem = (rd_addr_MEMWB == rt_addr_IDEX) && (regwrite_MEMWB == 1);

  // Check for forwarding from execution stage
  assign rs_from_ex = (rd_addr_EXMEM == rs_addr_IDEX) && (regwrite_EXMEM == 1);
  assign rt_from_ex = (rd_addr_EXMEM == rt_addr_IDEX) && (regwrite_EXMEM == 1);

  // Determine which forwarding signals to use
  assign forwardA = (rs_from_mem | rs_from_ex) ? 2'b10 : 2'b00;
  assign forwardB = (rt_from_mem | rt_from_ex) ? 2'b10 : 2'b00;

endmodule