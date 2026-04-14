module top_module(
  input clk,
  input wr_en,
  input rd_en,
  input [n-1:0] addr,
  input [n-1:0] data_in,
  output [n-1:0] data_out
);parameter n = 2; // number of read and write ports
parameter m = 16; // number of memory locations in the array

reg [n-1:0] data_out_reg; // register to hold data output

// define memory array
reg [n-1:0] mem [0:m-1];

// write operation
always @(posedge clk) begin
  if (wr_en) begin
    mem[addr] <= data_in;
  end
end

// read operation
always @(posedge clk) begin
  if (rd_en) begin
    data_out_reg <= mem[addr];
  end
end

// assign data output
assign data_out = data_out_reg;

endmodule