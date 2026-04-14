module top_module(
  input clka,
  input wea,
  input [9:0] addra,
  input [7:0] dina,
  output [7:0] douta
);// Use memory instantiation (e.g., RAMB36E1 for Xilinx, or other appropriate memory primitive)
  reg [7:0] mem [0:1023]; // Declare a memory with 1024 depth and 8-bit width
  reg [7:0] mem_out;

  always @(posedge clka) begin
    if (wea) begin
      mem[addra] <= dina; // Write operation
    end
    mem_out <= mem[addra]; // Read operation
  end

  assign douta = mem_out;

endmodule