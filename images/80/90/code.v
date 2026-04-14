module top_module(
  input clock,
  input [31:0] data,
  input [4:0] rdaddress,
  input [4:0] wraddress,
  input wren,
  output [31:0] q
);reg [31:0] ram [0:31]; // Declare a RAM with 32 words of 32 bits
  reg [31:0] ram_q; // Register to hold the output q
  
  always @(posedge clock) begin
    if (wren) begin
      ram[wraddress] <= data; // Write data to RAM
    end
  end
  
  always @(posedge clock) begin
    ram_q <= ram[rdaddress]; // Read from RAM
  end

  assign q = ram_q; // Assign output q to the value read from RAM

endmodule