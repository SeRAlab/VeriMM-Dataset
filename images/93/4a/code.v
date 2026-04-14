module top_module(
  input clk,
  input en,
  input signed [15:0] in,
  output signed [15:0] out
);parameter gain_init = 1;
parameter gain_min = 0.5;
parameter gain_max = 2;
parameter gain_step = 0.1;

reg signed [15:0] out_reg;
reg signed [15:0] error_reg;
reg signed [15:0] error_int_reg;
reg signed [15:0] in_reg;
reg signed [15:0] gain_reg;

parameter kp = 0.1;
parameter ki = 0.01;

always @(posedge clk) begin
  if (en) begin
    in_reg <= in;
    error_reg <= out_reg - in_reg;
    error_int_reg <= error_int_reg + error_reg;
    gain_reg <= gain_reg + (kp * error_reg) + (ki * error_int_reg);
    if (gain_reg > gain_max) begin
      gain_reg <= gain_max;
    end else if (gain_reg < gain_min) begin
      gain_reg <= gain_min;
    end
    out_reg <= gain_reg * in_reg;
  end else begin
    out_reg <= in;
    gain_reg <= gain_init;
    error_reg <= 0;
    error_int_reg <= 0;
  end
end

assign out = out_reg;

endmodule