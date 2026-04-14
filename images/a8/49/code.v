module top_module(
  input ref_clk,
  input ctrl,
  output out_clk
);parameter N = 10; // multiplication factor of the PLL
parameter M = 2; // division factor of the PLL

reg [31:0] phase_accumulator = 0;
reg [31:0] phase_increment = 0;
reg [31:0] divider_counter = 0;

always @ (posedge ref_clk) begin
  phase_accumulator <= phase_accumulator + phase_increment;
  if (phase_accumulator >= 2**32/N) begin
    phase_accumulator <= phase_accumulator - 2**32/N;
    divider_counter <= divider_counter + 1;
  end
end

always @ (posedge ctrl) begin
  phase_increment <= ctrl * 2**32/N;
  divider_counter <= 0;
end

assign out_clk = ref_clk * N/M;

endmodule