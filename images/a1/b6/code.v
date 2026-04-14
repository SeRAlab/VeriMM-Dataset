module top_module(
  input clk,
  input wr_en,
  input rd_en,
  input [2:0] addr1, // log2(8) = 3
  input [2:0] addr2, // log2(8) = 3
  input [7:0] data_in, // 8 bits for width
  output reg [7:0] data_out1, // 8 bits for width
  output reg [7:0] data_out2 // 8 bits for width
);parameter n = 8; // number of registers
parameter w = 8; // width of each register (in bits)
 
reg [w-1:0] registers [0:n-1]; // array of registers

always @(posedge clk) begin
  if (rd_en) begin
    data_out1 <= registers[addr1];
    if (addr2 != 0) data_out2 <= registers[addr2];
  end
  if (wr_en) begin
    registers[addr1] <= data_in;
    if (addr2 != 0) registers[addr2] <= data_in;
  end
end

endmodule