module top_module(
  input ref_clk,
  input data_clk,
  input reset,
  output reg pll_clk, // Changed to reg
  output reg dll_clk  // Changed to reg
);parameter pll_mult = 2;
parameter pll_div = 1;
parameter dll_delay = 1;

reg [31:0] pll_counter = 0;
reg [31:0] dll_counter = 0;

always @(posedge ref_clk or posedge reset) begin
  if (reset) begin
    pll_counter <= 0;
    pll_clk <= 0; // Add initial value for pll_clk
  end else begin
    if (pll_counter >= (pll_mult - 1)) begin
      pll_clk <= ~pll_clk; // Toggle pll_clk
      pll_counter <= 0;
    end else begin
      pll_counter <= pll_counter + 1;
    end
  end
end

always @(posedge data_clk or posedge reset) begin
  if (reset) begin
    dll_counter <= 0;
    dll_clk <= 0; // Add initial value for dll_clk
  end else begin
    if (dll_counter >= dll_delay) begin
      dll_clk <= data_clk; // Assign data_clk to dll_clk
      dll_counter <= 0;
    end else begin
      dll_counter <= dll_counter + 1;
    end
  end
end

endmodule