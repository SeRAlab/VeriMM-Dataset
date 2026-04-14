module top_module(
  input clk,            // Added clock input
  input read,
  input write,
  input [n-1:0] address,
  input [m-1:0] data_in,
  output [m-1:0] data_out
);parameter n = 8; // number of address lines
parameter m = 16; // number of data lines

reg [m-1:0] memory [2**n-1:0]; // memory array

assign data_out = (read && !write) ? memory[address] : {m{1'b0}}; // read operation, used concatenation for safety

always @ (posedge clk) begin
  if (write && !read) begin // write operation
    memory[address] <= data_in;
  end
end

endmodule