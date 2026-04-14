module top_module(
  input clk,
  input [7:0] din,
  input we,
  input rst,
  output reg [7:0] dout // Changed 'output' to 'output reg' to allow assignment in always block
);parameter depth = 16; // depth of the memory block

reg [7:0] mem [0:depth-1]; // register array to store data entries
reg [3:0] ptr; // pointer to most recently written data entry

always @(posedge clk) begin
  if (rst) begin
    ptr <= 0; // reset pointer to 0
    dout <= 8'hzz; // output undefined data
  end
  else begin
    if (we) begin
      mem[ptr] <= din; // write data to memory
      ptr <= ptr + 1; // increment pointer
    end
    dout <= mem[ptr-1]; // output most recently written data
  end
end

endmodule