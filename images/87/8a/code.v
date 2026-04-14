module top_module(
  input clk,
  input write_en1,
  input write_en2,
  input [WIDTH-1:0] addr1,
  input [WIDTH-1:0] addr2,
  input [WIDTH-1:0] din1,
  input [WIDTH-1:0] din2,
  output reg [WIDTH-1:0] dout1, // Change to reg
  output reg [WIDTH-1:0] dout2  // Change to reg
);parameter WIDTH = 8; // width of the data bus

reg [WIDTH-1:0] mem1 [0:2**WIDTH-1]; // memory array for port 1
reg [WIDTH-1:0] mem2 [0:2**WIDTH-1]; // memory array for port 2

always @(posedge clk) begin
  if (write_en1) // write operation for port 1
    mem1[addr1] <= din1;
  if (write_en2) // write operation for port 2
    mem2[addr2] <= din2;
  dout1 <= mem1[addr1]; // read operation for port 1
  dout2 <= mem2[addr2]; // read operation for port 2
end

endmodule