module top_module(
  input [n-1:0] in,
  input clk,
  output reg [n-1:0] out // Change output to 'reg' type
);parameter n = 4; // number of data signals
parameter d = 2; // delay of the retiming block

reg [n-1:0] shift_reg [0:d-1]; // shift register for delaying input data signals

integer i;

always @(posedge clk) begin
  // shift data into the shift register
  for (i = d-1; i > 0; i = i - 1) begin
    shift_reg[i] <= shift_reg[i-1];
  end
  shift_reg[0] <= in;
  
  // synchronize output data signals with input clock signal
  out <= shift_reg[d-1]; // This is now valid since out is a reg
end

endmodule