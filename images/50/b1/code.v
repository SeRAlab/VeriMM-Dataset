module top_module(
  input clk,
  input wr_en,
  input [n-1:0] wr_addr,
  input [m-1:0] wr_data,
  input [n-1:0] rd_addr1,
  input [n-1:0] rd_addr2,
  output reg [m-1:0] rd_data1,
  output reg [m-1:0] rd_data2
);parameter n = 4; // number of address lines
parameter m = 8; // number of data lines
parameter k = 4; // number of registers (2^k)

reg [m-1:0] registers [0:(2**k)-1];

always @(posedge clk) begin
  if (wr_en) begin
    registers[wr_addr] <= wr_data;
  end
  rd_data1 <= registers[rd_addr1];
  rd_data2 <= registers[rd_addr2];
end

endmodule