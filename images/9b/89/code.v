module top_module(
  input clock,
  input [31:0] data,
  input [4:0] rdaddress,
  input [4:0] wraddress,
  input wren,
  output reg [31:0] q
);// Declare a memory array for the register bank
  reg [31:0] registers [31:0];

  always @(posedge clock) begin
    // Write data to the register bank if wren is high
    if (wren) begin
      registers[wraddress] <= data;
    end
  end

  always @(posedge clock) begin
    // Read data from the register bank
    q <= registers[rdaddress];
  end

endmodule