module top_module(clk, we, addr, din, dout);input clk, we;
  input [1:0] addr;
  input [3:0] din;
  output [3:0] dout;

  reg [3:0] ram [0:3];

  always @(posedge clk) begin
    if (we) begin
      ram[addr] <= din;
    end
  end

  assign dout = ram[addr];

endmodule