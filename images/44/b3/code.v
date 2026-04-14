module top_module(
  input clk,
  input we,
  input [15:0] addr,
  input [15:0] data_in,
  output [15:0] data_out,
  input rd_en
);reg [15:0] mem [0:65535];
  reg [15:0] read_data;

  always @(posedge clk) begin
    if (we) begin
      mem[addr] <= data_in;
    end
  end

  always @(negedge clk) begin
    if (rd_en) begin
      read_data <= mem[addr];
    end
  end

  assign data_out = read_data;

endmodule