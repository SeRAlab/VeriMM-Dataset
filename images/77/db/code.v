module top_module(
  input [n-1:0] in,
  input shift,
  input dir,
  output [m-1:0] out
);parameter n = 4; // number of input signals
parameter m = 4; // number of output signals
parameter p = 8; // number of stages in the shift register

reg [p-1:0] shift_reg;

always @(posedge shift) begin
  if (dir == 0) begin // shift right
    shift_reg <= {shift_reg[p-2:0], in};
  end else begin // shift left
    shift_reg <= {in, shift_reg[p-1:1]};
  end
end

assign out = shift_reg[m-1:0];

endmodule