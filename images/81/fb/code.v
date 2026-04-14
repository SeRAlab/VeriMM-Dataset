module top_module(
  input ref_clk,
  input clk_in,
  input enable,
  input reset,
  output reg clk_out
);parameter delay_bits = 4;
parameter max_delay = 15;

reg [delay_bits-1:0] delay_reg;
reg [delay_bits-1:0] delay_next;
reg [delay_bits-1:0] delay_inc;
reg [delay_bits-1:0] delay_dec;

reg ref_clk_reg;
reg clk_in_reg;
reg [delay_bits-1:0] delay_reg_reg;
reg [delay_bits-1:0] delay_next_reg;
reg [delay_bits-1:0] delay_inc_reg;
reg [delay_bits-1:0] delay_dec_reg;

wire phase_error;
wire phase_error_reg;

assign phase_error = (ref_clk_reg == 1'b1) && (clk_in_reg == 1'b0);
assign phase_error_reg = (ref_clk_reg == 1'b1) && (clk_in_reg == 1'b0);

always @(posedge ref_clk) begin
  ref_clk_reg <= ref_clk;
  clk_in_reg <= clk_in;
  delay_reg_reg <= delay_reg;
  delay_next_reg <= delay_next;
  delay_inc_reg <= delay_inc;
  delay_dec_reg <= delay_dec;
end

always @(posedge clk_in) begin
  if (reset) begin
    delay_reg <= 0;
    delay_next <= 0;
  end else if (enable) begin
    if (phase_error_reg) begin
      if (delay_reg == max_delay) begin
        delay_next <= delay_reg;
      end else begin
        delay_next <= delay_reg + 1;
      end
    end else begin
      if (delay_reg == 0) begin
        delay_next <= delay_reg;
      end else begin
        delay_next <= delay_reg - 1;
      end
    end
  end
end

always @(posedge ref_clk) begin
  if (reset) begin
    delay_reg <= 0;
  end else if (enable) begin
    delay_reg <= delay_next;
  end
end

always @(posedge clk_in) begin
  if (reset) begin
    clk_out <= 0;
  end else if (enable) begin
    clk_out <= #delay_reg_reg clk_in;
  end
end

always @(*) begin
  if (delay_reg == max_delay) begin
    delay_inc = 0;
  end else begin
    delay_inc = delay_reg + 1;
  end
  if (delay_reg == 0) begin
    delay_dec = 0;
  end else begin
    delay_dec = delay_reg - 1;
  end
end

endmodule