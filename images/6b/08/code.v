module top_module(
  input clk, // Added clk input
  input [n-1:0] in,
  output [m-1:0] out
);parameter n = 4; // number of input signals
parameter m = 4; // number of output signals
parameter delay = 2; // number of clock cycles of delay

reg [n-1:0] shift_reg [0:delay-1];

integer i;

always @(posedge clk) begin
  for (i = delay-1; i > 0; i = i - 1) begin
    shift_reg[i] <= shift_reg[i-1];
  end
  shift_reg[0] <= in;
end

assign out = shift_reg[delay-1];

endmodule