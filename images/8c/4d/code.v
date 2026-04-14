module top_module(
  input clock,
  input [15:0] data,
  input [7:0] rdaddress1,
  input rden1,
  input [7:0] wraddress1,
  input wren1,
  input [7:0] rdaddress2,
  input rden2,
  input [7:0] wraddress2,
  input wren2,
  output reg [15:0] q1,
  output reg [15:0] q2
);// Memory declaration
  reg [15:0] memory [255:0]; // Define 256x16 memory

  always @(posedge clock) begin
    // Write operation for port 1
    if (wren1) begin
      memory[wraddress1] <= data;
    end
    // Read operation for port 1
    if (rden1) begin
      q1 <= memory[rdaddress1];
    end else begin
      q1 <= 16'd0;
    end
  end

  always @(posedge clock) begin
    // Write operation for port 2
    if (wren2) begin
      memory[wraddress2] <= data;
    end
    // Read operation for port 2
    if (rden2) begin
      q2 <= memory[rdaddress2];
    end else begin
      q2 <= 16'd0;
    end
  end

endmodule