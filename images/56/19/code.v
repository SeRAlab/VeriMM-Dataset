module top_module(
  input clk,
  input reset,
  input read_enable,
  input write_enable,
  input [address_width-1:0] address,
  input [data_width-1:0] write_data,
  output reg [data_width-1:0] read_data
);parameter data_width = 8; // width of data bus
parameter address_width = 16; // width of address bus
parameter memory_depth = 1024; // depth of memory

reg [data_width-1:0] memory [memory_depth-1:0];

always @(posedge clk) begin
  if (reset) begin
    read_data <= 0;
  end else begin
    if (read_enable) begin
      read_data <= memory[address];
    end else if (write_enable) begin
      memory[address] <= write_data;
    end
  end
end

endmodule