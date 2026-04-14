module top_module(
  input in,
  output out
);parameter delay = 10; // delay in time units

reg [delay-1:0] shift_reg;
reg clk;

always @(posedge clk) begin
  shift_reg <= {in, shift_reg[delay-2:0]};
end

assign out = shift_reg[delay-1];

endmodule