module top_module(
    input clk,
    input ena,
    input [11:0] addr,
    input [7:0] din,
    input we,
    output reg [7:0] dout
  );reg [7:0] mem [0:4095];

  always @(posedge clk) begin
    if (ena && !we) begin
      dout <= mem[addr];
    end else if (ena && we) begin
      mem[addr] <= din;
    end else begin
      dout <= 8'b0;
    end
  end

endmodule