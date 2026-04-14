module top_module(
  input clk,
  input [15:0] addr,
  input [7:0] din,
  input we,
  output reg [7:0] dout  // Changed 'output' to 'output reg'
);reg [7:0] mem [0:63];

  always @(posedge clk) begin
    if (we) begin
      mem[addr[5:0]] <= din; // Corrected the memory writing syntax
    end
    dout <= mem[addr[5:0]]; // No need for [7:0], since dout is already 8 bits.
  end

endmodule