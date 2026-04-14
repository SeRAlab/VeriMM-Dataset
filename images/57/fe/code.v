module top_module(
  input wire clk,
  input [width-1:0] data_in,
  output reg [width-1:0] data_out // Changed wire to reg
);parameter width = 8; // width of the data input and output signals

reg [width-1:0] stored_data;

always @(posedge clk) begin
  stored_data <= data_in;
  data_out <= stored_data; // Moved this assignment into the same always block
end

endmodule