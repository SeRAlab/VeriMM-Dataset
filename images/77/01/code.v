module top_module(
  input [n-1:0] in,
  input shift_en,
  input shift_dir,
  output [n-1:0] out,
  output serial_out,
  output [parallel_width-1:0] parallel_out
);parameter n = 8; // number of input signals
parameter parallel_width = 4; // width of parallel output signal

reg [n-1:0] shift_reg; // shift register

// Shift operation
always @ (posedge shift_en) begin
  if (shift_dir == 1) begin // Shift left
    shift_reg <= {shift_reg[n-2:0], in[n-1]};
  end else begin // Shift right
    shift_reg <= {in[0], shift_reg[n-2:1]};
  end
end

// Output signals
assign out = shift_reg;
assign serial_out = shift_reg[n-1:0];
assign parallel_out = shift_reg[n-1:n-parallel_width];

endmodule