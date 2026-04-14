module top_module(
  input clock,
  input [31:0] data,
  input [4:0] rdaddress,
  input [4:0] wraddress,
  input wren,
  output reg [31:0] q
);reg [31:0] ram [0:31]; // Assuming a 32x32 register bank
  always @(posedge clock) begin
    if (wren) begin
      ram[wraddress] <= data; // Write operation
    end
    q <= ram[rdaddress]; // Read operation
  end

endmodule