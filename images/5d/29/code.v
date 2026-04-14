module top_module(
  input clk,
  input rst,
  input wen,
  input ren,
  input [w-1:0] din,
  input [log2_n-1:0] sel, // Updated the input selection based on pre-calculated log2
  output [w-1:0] dout
);parameter n = 4; // number of registers
  parameter w = 8; // width of each register (in bits)

  localparam log2_n = $clog2(n); // Use $clog2 to get the ceiling of log2(n)

  reg [w-1:0] registers [0:n-1]; // array of registers

  integer i; // Declare an integer for for-loop
  
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      // Reset all registers to 0
      for (i = 0; i < n; i = i + 1) begin
        registers[i] <= 0;
      end
    end else if (wen) begin
      registers[sel] <= din;
    end
  end

  assign dout = (ren) ? registers[sel] : 0;

endmodule