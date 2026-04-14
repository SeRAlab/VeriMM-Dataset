module top_module(
  input clk,
  input in,
  output out
);parameter n = 8; // number of clock cycles to delay

reg [n-1:0] shift_reg; // shift register with n stages

always @(posedge clk) begin
  shift_reg <= {in, shift_reg[n-1:1]}; // shift input signal into shift register
end

assign out = shift_reg[0]; // output delayed signal

endmodule