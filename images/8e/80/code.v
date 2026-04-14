module top_module(
  input write_enable,
  input [ADDRESS_WIDTH-1:0] write_address,
  input [width-1:0] write_data,
  input read_enable1,
  input [ADDRESS_WIDTH-1:0] read_address1,
  input read_enable2,
  input [ADDRESS_WIDTH-1:0] read_address2,
  output reg [width-1:0] read_data1,
  output reg [width-1:0] read_data2
);parameter width = 8; // width of data bus
parameter depth = 256; // depth of memory block
parameter num_ports = 2; // number of ports

localparam ADDRESS_WIDTH = $clog2(depth); // Calculate the address width

reg [width-1:0] mem [0:depth-1]; // memory block

always @(*) begin
  if (write_enable) begin
    mem[write_address] <= write_data;
  end
end

always @(*) begin
  if (read_enable1) begin
    read_data1 <= mem[read_address1];
  end
  if (read_enable2) begin
    read_data2 <= mem[read_address2];
  end
end

endmodule