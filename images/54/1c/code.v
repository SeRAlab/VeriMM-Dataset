module top_module(
    input clk,
    input [15:0] mem_addr,
    input [15:0] data_in,
    output [15:0] data_out,
    output [ADDR_BITS-1:0] addr,
    output en
    );parameter ADDR_BITS = 16;
  parameter START = 16'b0;
  parameter SIZE = 16'b0;
  localparam END = START + SIZE;

  reg out_en = 1'b0;
  wire [15:0] mapped_addr;
  assign mapped_addr = mem_addr - START;
  assign en = addr >= START & addr < END;
  assign addr = mapped_addr[ADDR_BITS-1:0];
  assign data_out = out_en ? data_in : 16'b0;

  always @(posedge clk)
    out_en <= en;
endmodule