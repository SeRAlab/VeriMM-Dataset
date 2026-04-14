module top_module(
  input [ADDRESS_WIDTH-1:0] address,
  input [data_width-1:0] data_in,
  input write_enable,
  output reg [data_width-1:0] data_out
);parameter data_width = 8; // width of the data bus
parameter depth = 256; // number of words in the memory
localparam ADDRESS_WIDTH = $clog2(depth); // use $clog2 to compute the log base 2 of depth

reg [data_width-1:0] memory [0:depth-1];

always @* begin
  data_out = memory[address]; // use an always block for combinational output
end

always @ (posedge write_enable) begin
  if (write_enable) begin
    memory[address] <= data_in;
  end
end

endmodule