module top_module(
  input clk,
  input [7:0] data_in,
  output [7:0] data_out
);parameter delay = 4; // number of clock cycles to delay the data signal

reg [7:0] shift_reg [0:delay-1]; // shift register to delay the data signal

integer i;

always @(posedge clk) begin
  // shift the data signal through the shift register
  for (i = delay-1; i > 0; i = i - 1) begin
    shift_reg[i] <= shift_reg[i-1];
  end
  shift_reg[0] <= data_in;
end

assign data_out = shift_reg[delay-1]; // output the retimed data signal

endmodule