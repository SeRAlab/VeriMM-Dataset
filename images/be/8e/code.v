module top_module(
  input clk,
  input we,
  input [9:0] addr,
  input [7:0] din,
  input [9:0] read_addr,
  output reg [7:0] dout,
  output reg [7:0] q
);reg [7:0] mem [0:1023];

always @(posedge clk) begin
  if (we) begin
    mem[addr] <= din;
  end
  dout <= mem[addr];
end

assign q = mem[read_addr];

endmodule