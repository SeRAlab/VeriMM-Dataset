module top_module(
  input clk,     // Added clk input
  input in,
  output out
);parameter delay = 10; // delay in time units

reg [delay-1:0] shift_reg; // shift register to store input signal

always @(posedge clk) begin
  shift_reg <= {in, shift_reg[delay-2:0]}; // shift input signal into shift register
end

assign out = shift_reg[delay-1]; // output delayed signal

endmodule