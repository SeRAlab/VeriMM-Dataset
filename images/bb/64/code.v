module top_module(
  input [n-1:0] data_in,
  input [k-1:0] reg_select,
  input write_en,
  input reset,
  input clk,          // Added clock input
  output [m-1:0] data_out
);parameter n = 8; // number of bits in each data input signal
parameter m = 8; // number of bits in each data output signal
parameter k = 8; // number of registers in the register file

reg [n-1:0] registers [0:k-1]; // array of k registers, each n bits wide

assign data_out = (reg_select < k) ? registers[reg_select] : 0; // read operation using a multiplexer

integer i; // Declare integer variable for loop index

always @ (posedge clk) begin // write operation using a tri-state buffer
  if (write_en) begin
    registers[reg_select] <= data_in;
  end
end

always @ (posedge clk) begin // reset operation
  if (reset) begin
    for (i = 0; i < k; i = i + 1) begin
      registers[i] <= 0;
    end
  end
end

endmodule