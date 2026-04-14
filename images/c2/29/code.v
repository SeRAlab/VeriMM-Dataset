module delay_line (
  input clk,
  input rst,
  input din,
  output dout
);

parameter delay = 3; // number of clock cycles of delay

reg [delay-1:0] shift_reg;
reg [delay-1:0] delayed_out;

always @(posedge clk) begin
  if (rst) begin
    shift_reg <= 0;
    delayed_out <= 0;
  end else begin
    shift_reg <= {din, shift_reg[delay-2:0]};
    delayed_out <= shift_reg[delay-1:0];
  end
end

assign dout = delayed_out;

endmodule