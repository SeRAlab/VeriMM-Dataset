module top_module(
  input wire clk,
  input wire we,
  input wire [12:0] addr,
  input wire [11:0] din,
  output reg [11:0] dout
);reg [11:0] mem [5777:0];
  integer i;

  always @(posedge clk) begin
    if (we) begin
      mem[addr] <= din;
    end
    dout <= mem[addr];
  end

endmodule