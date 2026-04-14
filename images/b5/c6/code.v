module top_module(clk, we, addr, din, rd_en, dout);parameter RAM_DEPTH = 2048;
  parameter RAM_WIDTH = 10;
  input clk, we, rd_en;
  input [10:0] addr; // Address width must accommodate RAM_DEPTH
  input [9:0] din;   // Data input width matches RAM_WIDTH 
  output reg [9:0] dout; // dout should be a reg since it's driven in an always block

  // Memory array definition
  reg [9:0] ram [0:RAM_DEPTH-1]; // RAM memory declaration

  // Read and Write Operations
  always @(posedge clk) begin
    if (we) begin
      ram[addr] <= din; // Write operation
    end
    if (rd_en) begin
      dout <= ram[addr]; // Read operation
    end
  end
endmodule