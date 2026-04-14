module top_module(
  input clock,
  input [31:0] data_a,
  input wren_a,
  input [4:0] address_a,
  input [31:0] data_b,
  input wren_b,
  input [4:0] address_b,
  input rd_en_a,
  input rd_en_b,
  output reg [31:0] q_a,
  output reg [31:0] q_b
);reg [31:0] mem [0:31];

  always @(posedge clock) begin
    if (wren_a) mem[address_a] <= data_a;
    if (wren_b) mem[address_b] <= data_b;
    if (rd_en_a) q_a <= mem[address_a];
    if (rd_en_b) q_b <= mem[address_b];
  end

endmodule