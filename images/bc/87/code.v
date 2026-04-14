module top_module(
  input clk,
  input [31:0] data_in,
  input write_en,
  input [4:0] read_address_1,
  input [4:0] read_address_2,
  output reg [31:0] read_data_1,
  output reg [31:0] read_data_2
);reg [31:0] registers [0:31]; // 32 registers of 32-bits each

  // Write operation if write_en is high
  always @(posedge clk) begin
    if (write_en) begin
      registers[read_address_1] <= data_in; // Store data in the specified register
    end
  end

  // Read operation for read data 1 and read data 2
  always @(posedge clk) begin
    read_data_1 <= registers[read_address_1]; // Output for first read address
    read_data_2 <= registers[read_address_2]; // Output for second read address
  end

endmodule