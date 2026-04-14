module top_module(
  input clk, // Added clk input
  input [n-1:0] in,
  input ctrl,
  output [n-1:0] out
);parameter n = 8; // number of flip-flops in the shift register
parameter direction = 1; // direction of the shift operation (0 = right, 1 = left)

reg [n-1:0] shift_reg; // register to store the data

always @(posedge clk) begin
  if (ctrl == 1) begin // shift left
    shift_reg <= {shift_reg[n-2:0], in[n-1]};
  end else begin // shift right
    shift_reg <= {in[0], shift_reg[n-1:1]};
  end
end

assign out = shift_reg;

endmodule