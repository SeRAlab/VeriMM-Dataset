module top_module(
  input clk, reset, reset_req, clken, chipselect, write,
  input [8:0] address, byteenable,
  input [63:0] writedata,
  output reg [63:0] readdata
);parameter INIT_FILE = "onchip_trace_mem.hex";
  parameter WIDTH = 64;
  parameter DEPTH = 512;
  parameter ADDR_WIDTH = 9;
  parameter BYTE_WIDTH = 8;

  wire wren;
  assign wren = chipselect & write;

  wire clocken0;
  assign clocken0 = clken & ~reset_req;

  // Replace altsyncram with a generic RAM implementation
  reg [WIDTH-1:0] ram [0:DEPTH-1]; // Declare a RAM block
  integer i;

  // Read Operation
  always @(posedge clk) begin
    if (reset) begin
      readdata <= 0;
    end else if (~reset_req & clken) begin
      if (!wren) begin
        readdata <= ram[address]; // Read data from RAM
      end
    end
  end

  // Write Operation
  always @(posedge clk) begin
    if (wren) begin
      ram[address] <= writedata; // Write data to RAM
    end
  end

  // Optional: Initialize memory from a file if you have an initialization method
  initial begin
    // Initialize memory if needed (this implementation assumes RAM is initialized to zero)
    for (i = 0; i < DEPTH; i = i + 1) begin
      ram[i] = 64'b0;
    end
  end

endmodule