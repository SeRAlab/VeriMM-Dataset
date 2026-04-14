module top_module(
  input [width-1:0] data_in1,
  input [width-1:0] data_in2,
  input [depth-1:0] address1,
  input [depth-1:0] address2,
  input write_en1,
  input write_en2,
  input clock,
  output reg [width-1:0] data_out1, // Changed to reg
  output reg [width-1:0] data_out2  // Changed to reg
);parameter depth = 256; // depth of the RAM block
parameter width = 8; // width of the RAM block

reg [width-1:0] mem [0:depth-1];

always @(posedge clock) begin
  if (write_en1) begin
    mem[address1] <= data_in1;
  end
  if (write_en2) begin
    mem[address2] <= data_in2;
  end
  data_out1 <= mem[address1];
  data_out2 <= mem[address2];
end

endmodule