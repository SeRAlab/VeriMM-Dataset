module top_module(
  input clk,
  input wen,
  input [5:0] waddr,
  input [5:0] raddr1,
  input [5:0] raddr2,
  input [31:0] wdata,
  output [31:0] rdata1,
  output [31:0] rdata2
);reg [31:0] regs [0:30]; // 31 registers, each with 32 bits

  always @(posedge clk) begin
    if (wen) regs[waddr] <= wdata; // write operation
  end

  assign rdata1 = regs[raddr1]; // first read operation
  assign rdata2 = regs[raddr2]; // second read operation

endmodule