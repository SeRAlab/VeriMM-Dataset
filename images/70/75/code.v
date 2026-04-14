module top_module(
  input rst,
  input clk,
  input write_enable,
  input [REG_WIDTH-1 : 0] rs1_offset,
  input [REG_WIDTH-1 : 0] rs2_offset,
  input [REG_WIDTH-1 : 0] rd_offset,
  input [WIDTH-1 : 0] rd_data_in,
  output [WIDTH-1 : 0] rs1_data_out,
  output [WIDTH-1 : 0] rs2_data_out);parameter REG_WIDTH = 5;
  parameter WIDTH = 32;
  parameter STACK_REG = 2;
  parameter STACK_START = 1024; //1k
  localparam REG_COUNT = 1 << REG_WIDTH;
  reg [WIDTH-1 : 0] regs [0 : REG_COUNT-1];

  // Initialize stack pointer on reset
  always @(posedge clk) begin
    if (rst) begin
      regs[STACK_REG] <= STACK_START;
    end
  end

  // Write to register on clock edge
  always @(posedge clk) begin
    if (write_enable && (rd_offset != 0)) begin
      regs[rd_offset] <= rd_data_in;
    end
  end

  // Output data on each cycle
  assign rs1_data_out = regs[rs1_offset];
  assign rs2_data_out = regs[rs2_offset];

endmodule