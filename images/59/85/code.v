module top_module(
  input clk,
  input wr_en_A,
  input wr_en_B,
  input rd_en_A,
  input rd_en_B,
  input [addr_width-1:0] addr_A,
  input [addr_width-1:0] addr_B,
  input [data_width-1:0] data_in_A,
  input [data_width-1:0] data_in_B,
  output reg [data_width-1:0] data_out_A,
  output reg [data_width-1:0] data_out_B
);parameter data_width = 8; // width of input and output data signals
parameter addr_width = 4; // width of address signals

reg [data_width-1:0] mem [0:(2**addr_width)-1];

always @(posedge clk) begin
  if (wr_en_A) mem[addr_A] <= data_in_A;
  if (wr_en_B) mem[addr_B] <= data_in_B;
  if (rd_en_A) data_out_A <= mem[addr_A];
  if (rd_en_B) data_out_B <= mem[addr_B];
end

endmodule