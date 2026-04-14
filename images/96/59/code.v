module top_module(
  input clk, // Added clk input
  input [n-1:0] ctrl,
  input [k-1:0] data_in,
  input write_en,
  output [m-1:0] data_out
);parameter k = 8; // number of bits in each register
parameter n = 4; // number of registers in the file
parameter m = 2; // number of data output signals

reg [k-1:0] registers [n-1:0];

always @ (posedge clk) begin
  if (write_en) begin
    registers[ctrl] <= data_in;
  end
end

assign data_out[0] = registers[ctrl[0]];
assign data_out[1] = registers[ctrl[1]];

endmodule