module top_module(
  input clk_ref,
  input data_in,
  input en,
  output reg data_out,
  output reg locked
);// Define parameters
  parameter DELAY_LINE_LENGTH = 16;
  parameter PHASE_DETECT_THRESHOLD = 8;
  parameter LPF_COEFF = 0.125;

  // Define internal signals
  reg [DELAY_LINE_LENGTH-1:0] delay_line;
  reg [DELAY_LINE_LENGTH-1:0] delayed_data;
  reg [DELAY_LINE_LENGTH-1:0] delayed_clk;
  reg [1:0] phase_detect_out;
  reg [1:0] phase_detect_out_delayed;
  reg [7:0] control_voltage;
  reg [7:0] control_voltage_filtered;
  reg locked_delayed;

  // Define phase detector
  always @(posedge clk_ref) begin
    phase_detect_out <= {data_in, delayed_data} > PHASE_DETECT_THRESHOLD ? 2'b01 : 2'b10;
  end

  // Define low-pass filter
  always @(posedge clk_ref) begin
    control_voltage <= phase_detect_out - phase_detect_out_delayed;
    control_voltage_filtered <= (control_voltage_filtered << 3) + (control_voltage << 1) - control_voltage_filtered;
    phase_detect_out_delayed <= phase_detect_out;
  end

  // Define delay line
  always @(posedge clk_ref) begin
    if (en) begin
      delay_line <= {delay_line[DELAY_LINE_LENGTH-2:0], delayed_clk[0]};
      delayed_clk <= delay_line;
    end
  end

  // Define feedback loop
  always @(posedge clk_ref) begin
    if (en) begin
      delayed_data <= delay_line;
      data_out <= delayed_data[DELAY_LINE_LENGTH-1];
      locked_delayed <= (phase_detect_out == 2'b00) ? 1'b1 : 1'b0;
      locked <= locked_delayed;
    end
  end

endmodule