module top_module(
  input clk, // clock signal
  input we, // write enable signal
  input [log2depth-1:0] addr, // address signal
  input [width-1:0] din, // input data
  output reg [width-1:0] dout // output data
);parameter width = 8; // width of the data
parameter depth = 16; // depth of the memory
parameter log2depth = $clog2(depth); // log2 of the depth for indexing

// define memory array
reg [width-1:0] mem [0:depth-1];

// write data into the memory
always @(posedge clk) begin
  if (we) begin
    mem[addr] <= din;
  end
end

// read data from the memory
always @(posedge clk) begin
  if (!we) begin
    dout <= mem[addr];
  end
end

endmodule