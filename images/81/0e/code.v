module top_module(
  input clk,
  input rst,
  input in,
  output out
);parameter delay = 4; // number of clock cycles to delay the input signal

reg [delay-1:0] shift_reg;
reg [delay-1:0] delayed_out;

always @(posedge clk) begin
  if (rst) begin
    shift_reg <= 0;
    delayed_out <= 0;
  end
  else begin
    shift_reg <= {in, shift_reg[delay-1:1]};
    delayed_out <= shift_reg;
  end
end

assign out = delayed_out[delay-1];

endmodule