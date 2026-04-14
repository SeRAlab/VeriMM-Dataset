module top_module(
  input [n-1:0] in,
  input clk,
  input rst,
  output [n-1:0] out
);parameter n = 8; // number of input and output signals

reg [n-1:0] hold; // register to hold the data on the bus

always @(posedge clk) begin
  if (rst) begin
    hold <= 0; // reset the register to 0
  end else begin
    hold <= in; // latch the input signals on the rising edge of the clock
  end
end

assign out = hold; // assign the output signals to the register

endmodule