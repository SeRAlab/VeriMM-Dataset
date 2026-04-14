module shift_reg8bit
(
  input  [7:0] data_in,
  input  clk,
  input  load,
  output serial_out
);

reg [7:0] shift_reg;

always @(posedge clk) begin
  if (load)
    shift_reg <= data_in;
  else
    shift_reg <= {1'b0, shift_reg[7:1]};
end

assign serial_out = shift_reg[0];

endmodule