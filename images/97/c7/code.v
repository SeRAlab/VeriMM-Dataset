module top_module(
  input signed [15:0] signal_in,
  input signed [15:0] gain_ctrl,
  input reset,
  output signed [15:0] signal_out,
  output [7:0] gain_out
);parameter k = 8'h80; // AGC gain constant
parameter n = 8; // number of bits used to represent gain value

reg signed [15:0] signal_out_reg;
reg [7:0] gain_out_reg;
reg signed [15:0] error_reg;
reg signed [15:0] gain_reg;

always @(*) begin
  error_reg = signal_in - (signal_out_reg >> (n-1));
  gain_reg = gain_out_reg + (k * error_reg * gain_ctrl);
  if (gain_reg > (2**n - 1)) begin
    gain_out_reg = 2**n - 1;
  end else if (gain_reg < 1) begin
    gain_out_reg = 1;
  end else begin
    gain_out_reg = gain_reg;
  end
  signal_out_reg = gain_out_reg * signal_in;
end

assign signal_out = signal_out_reg;
assign gain_out = gain_out_reg;

always @(posedge reset) begin
  signal_out_reg <= 0;
  gain_out_reg <= 1;
end

endmodule