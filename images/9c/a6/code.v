module top_module(
  input clk,           // Added clock input
  input data_in,
  input shift_left,
  input shift_right,
  input hold,
  output data_out
);parameter n = 8; // number of bits in the shift register

reg [n-1:0] shift_reg;
wire [n-1:0] shift_left_reg;
wire [n-1:0] shift_right_reg;

assign shift_left_reg = {shift_reg[n-2:0], 1'b0};
assign shift_right_reg = {1'b0, shift_reg[n-1:1]};

always @(posedge clk) begin
  if (hold) begin
    shift_reg <= shift_reg;
  end else if (shift_left) begin
    shift_reg <= shift_left_reg;
  end else if (shift_right) begin
    shift_reg <= shift_right_reg;
  end else begin
    shift_reg <= {shift_reg[n-1:1], data_in}; // Ensure proper input assignment
  end
end

assign data_out = shift_reg[0];

endmodule