module top_module(
  input clock,
  input [31:0] data,
  input [4:0] rdaddress,
  input [4:0] wraddress,
  input wren,
  output reg [31:0] q
);reg [31:0] ram [31:0];  // Define a 32x32-bit register array
  reg [31:0] ram_q;       // Temporary variable to hold read data

  always @(posedge clock) begin
    if (wren) begin
      ram[wraddress] <= data; // Write data to specified address
    end
    ram_q <= ram[rdaddress];    // Read data from specified address
  end

  always @(*) begin
    q = ram_q;  // Update output q with read data
  end

endmodule