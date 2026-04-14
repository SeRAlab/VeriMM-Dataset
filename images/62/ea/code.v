module top_module(
  input clk,
  input [9:0] addr,
  output reg [799:0] dout
);reg [799:0] mem[0:1023];

  always @(posedge clk) begin
    dout <= mem[addr];
  end

endmodule