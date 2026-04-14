module top_module(
  input [0:0] AR,
  input [9:0] D,
  input rd_clk,
  output reg out,      // Changed output to reg
  output reg prog_empty // Changed output to reg
);reg [9:0] ram [0:1];

  always @(posedge rd_clk) begin
    out <= ram[AR];
    prog_empty <= (ram[AR] == 0);
  end

endmodule