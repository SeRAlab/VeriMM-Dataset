module top_module(
  input         clock,
  input         reset,
  input  [31:0] io_input_start,
  input  [31:0] io_input_max,
  input  [31:0] io_input_stride,
  input  [31:0] io_input_gap,
  input         io_input_reset,
  input         io_input_enable,
  input         io_input_saturate,
  output [31:0] io_output_count_0,
  output [31:0] io_output_countWithoutWrap_0,
  output        io_output_done,
  output        io_output_extendedDone,
  output        io_output_saturated
);reg [31:0] count_reg;
  reg [31:0] countWithoutWrap_reg;
  reg done_reg;
  reg extendedDone_reg;
  reg saturated_reg;
  
  always @(posedge clock) begin
    if (reset) begin
      count_reg <= io_input_start;
      countWithoutWrap_reg <= io_input_start;
      done_reg <= 1'b0;
      extendedDone_reg <= 1'b0;
      saturated_reg <= 1'b0;
    end else if (io_input_reset) begin
      count_reg <= io_input_start;
      countWithoutWrap_reg <= io_input_start;
      done_reg <= 1'b0;
      extendedDone_reg <= 1'b0;
      saturated_reg <= 1'b0;
    end else if (io_input_enable) begin
      count_reg <= (count_reg + io_input_stride + io_input_gap) >= io_input_max ? (io_input_saturate ? io_input_max : io_input_start) : (count_reg + io_input_stride + io_input_gap);
      countWithoutWrap_reg <= (countWithoutWrap_reg + io_input_stride);
      done_reg <= (count_reg == io_input_max);
      extendedDone_reg <= (done_reg && io_input_saturate);
      saturated_reg <= (count_reg >= io_input_max && io_input_saturate);
    end
  end
  
  assign io_output_count_0 = count_reg;
  assign io_output_countWithoutWrap_0 = countWithoutWrap_reg;
  assign io_output_done = done_reg;
  assign io_output_extendedDone = extendedDone_reg;
  assign io_output_saturated = saturated_reg;
  
endmodule