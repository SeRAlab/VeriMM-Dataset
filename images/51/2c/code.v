module top_module(
  input clk,
  input wr_en,
  input rd_en,
  input [11:0] addr,
  input [15:0] data_in,
  output [15:0] data_out
);reg [15:0] mem [0:4095];

  always @(posedge clk) begin
    if (wr_en) begin
      mem[addr] <= data_in;
    end
  end

  assign data_out = rd_en ? mem[addr] : 16'h0000;

endmodule