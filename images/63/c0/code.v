module top_module(
  input ref_clk,
  input feedback_clk,
  input [7:0] delay,
  output out_clk
);reg [7:0] delay_reg;
  reg [7:0] delay_next;
  reg [7:0] error;
  reg [7:0] error_filtered;
  reg [7:0] error_integrated;
  reg [7:0] error_integrated_next;
  reg [7:0] error_filtered_next;
  reg [7:0] phase_detector_out;
  reg [7:0] delay_line_out;
  reg [7:0] out_clk_reg;
  reg [7:0] out_clk_next;

  always @(posedge ref_clk) begin
    delay_reg <= delay;
    delay_next <= delay_reg;
    error <= phase_detector_out;
    error_filtered <= error_filtered_next;
    error_integrated <= error_integrated_next;
    out_clk_reg <= out_clk_next;
  end

  always @(posedge feedback_clk) begin
    delay_line_out <= delay_reg[7] ? feedback_clk : delay_line_out;
    delay_line_out <= delay_reg[6] ? delay_line_out : feedback_clk;
    delay_line_out <= delay_reg[5] ? delay_line_out : feedback_clk;
    delay_line_out <= delay_reg[4] ? delay_line_out : feedback_clk;
    delay_line_out <= delay_reg[3] ? delay_line_out : feedback_clk;
    delay_line_out <= delay_reg[2] ? delay_line_out : feedback_clk;
    delay_line_out <= delay_reg[1] ? delay_line_out : feedback_clk;
    delay_line_out <= delay_reg[0] ? delay_line_out : feedback_clk;

    phase_detector_out <= delay_line_out ^ feedback_clk;

    error_filtered_next <= (error_filtered + error) >> 1;
    error_integrated_next <= error_integrated + error_filtered_next;

    delay_next <= delay_reg + error_integrated_next;

    out_clk_next <= delay_reg[7] ? delay_line_out : out_clk_reg;
    out_clk_next <= delay_reg[6] ? out_clk_reg : delay_line_out;
    out_clk_next <= delay_reg[5] ? out_clk_reg : delay_line_out;
    out_clk_next <= delay_reg[4] ? out_clk_reg : delay_line_out;
    out_clk_next <= delay_reg[3] ? out_clk_reg : delay_line_out;
    out_clk_next <= delay_reg[2] ? out_clk_reg : delay_line_out;
    out_clk_next <= delay_reg[1] ? out_clk_reg : delay_line_out;
    out_clk_next <= delay_reg[0] ? out_clk_reg : delay_line_out;
  end

  assign out_clk = out_clk_reg;

endmodule