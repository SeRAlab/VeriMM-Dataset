module top_module(
  input clk_in,
  input clk_ref,
  input reset,
  output pll_locked,
  output pll_out,
  output dll_locked,
  output dll_out
);// Define PLL parameters
  parameter PLL_FREQ_MIN = 10_000_000; // 10 MHz
  parameter PLL_FREQ_MAX = 500_000_000; // 500 MHz
  parameter PLL_PHASE_MAX = 360; // degrees

  // Define DLL parameters
  parameter DLL_PHASE_MIN = 0; // degrees
  parameter DLL_PHASE_MAX = 360; // degrees

  // Define internal signals
  reg [31:0] pll_counter = 0;
  reg [31:0] dll_counter = 0;
  reg pll_locked_internal = 0;
  reg dll_locked_internal = 0;
  wire clk_out = 0;

  // Define PLL logic
  always @(posedge clk_ref or posedge reset) begin
    if (reset) begin
      pll_counter <= 0;
      pll_locked_internal <= 0;
    end else begin
      pll_counter <= pll_counter + 1;
      if (pll_counter >= (clk_ref / clk_in)) begin
        pll_counter <= 0;
        pll_locked_internal <= 1;
      end else begin
        pll_locked_internal <= 0;
      end
    end
  end

  // Define DLL logic
  always @(posedge clk_in or posedge reset) begin
    if (reset) begin
      dll_counter <= 0;
      dll_locked_internal <= 0;
    end else begin
      dll_counter <= dll_counter + 1;
      if (dll_counter >= (clk_in * (DLL_PHASE_MAX / 360))) begin
        dll_counter <= 0;
        dll_locked_internal <= 1;
      end else begin
        dll_locked_internal <= 0;
      end
    end
  end

  // Define output signals
  assign pll_locked = pll_locked_internal;
  assign dll_locked = dll_locked_internal;
  assign clk_out = (pll_locked_internal && dll_locked_internal) ? 1'b1 : 1'b0;
  assign pll_out = clk_out;
  assign dll_out = clk_out;

endmodule