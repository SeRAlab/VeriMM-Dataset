module top_module(
  input clk,
  input in,
  output out
);parameter delay = 4; // delay in clock cycles

// shift register to delay input signal
reg [delay-1:0] shift_reg;

always @(posedge clk) begin
  shift_reg <= {shift_reg[delay-2:0], in};
end

assign out = shift_reg[delay-1];

endmodule