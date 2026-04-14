module top_module(
  input clk,                 // added clock input
  input [n-1:0] in,
  output [m-1:0] out
);parameter n = 4; // number of input signals
parameter m = 2; // number of output signals
parameter d = 4; // depth of pipeline register

reg [n-1:0] shift_reg [0:d-1]; // shift register implemented using flip-flops

integer i;

always @ (posedge clk) begin
  // shift input signals into shift register
  for (i = d-1; i > 0; i = i - 1) begin
    shift_reg[i] <= shift_reg[i-1];
  end
  shift_reg[0] <= in;
end

// output signals are the values stored in the flip-flops
assign out = shift_reg[d-1][m-1:0]; // ensure correct width for output

endmodule