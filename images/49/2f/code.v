module top_module(
  input clk,
  input wen,
  input [31:0] addr,
  input [31:0] din,
  output reg [31:0] dout
);reg [31:0] mem [0:1023]; // 1024 memory locations, each 32 bits wide

  always @(posedge clk) begin
    if (wen) begin
      mem[addr] <= din; // write data to memory location specified by addr
    end else begin
      dout <= mem[addr]; // read data from memory location specified by addr
    end
  end

endmodule