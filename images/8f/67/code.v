module top_module(
  input clk,         // Add clock input
  input in,
  output out
);parameter delay = 5; // number of clock cycles of delay

reg [delay-1:0] shift_reg; // shift register to store delayed input

always @(posedge clk) begin
  shift_reg <= {shift_reg[delay-2:0], in}; // shift input into shift register
end

assign out = shift_reg[delay-1]; // output delayed input

endmodule