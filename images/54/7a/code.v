module top_module(
  input ref_clk,
  input local_clk,
  input reset,
  output locked,
  output reg adj_clk
);parameter n = 8; // number of delay stages
parameter d = 1; // delay increment
parameter k = 2; // gain of the feedback loop

reg [n-1:0] delay_line;
reg [n-1:0] delay_line_next;
reg [n-1:0] phase_error;
reg [n-1:0] phase_error_next;
reg [n-1:0] delay_ctrl;
reg [n-1:0] delay_ctrl_next;

integer i;
reg locked_next;

always @(posedge ref_clk or posedge reset) begin
  if (reset) begin
    delay_line <= 'b0;
    phase_error <= 'b0;
    delay_ctrl <= 'b0;
    locked_next <= 0;
  end else begin
    for (i = 0; i < n; i = i + 1) begin
      delay_line_next[i] = (i == 0) ? local_clk : delay_line[i-1];
      phase_error_next[i] = (delay_line_next[i] == ref_clk) ? 0 : (delay_line_next[i] < ref_clk) ? k : -k;
      delay_ctrl_next[i] = delay_ctrl[i] + phase_error_next[i];
      delay_ctrl_next[i] = (delay_ctrl_next[i] < 0) ? 0 : (delay_ctrl_next[i] > (n*d-1)) ? (n*d-1) : delay_ctrl_next[i];
      adj_clk = (i == n-1) ? delay_line_next[i] : adj_clk;
    end
    delay_line <= delay_line_next;
    phase_error <= phase_error_next;
    delay_ctrl <= delay_ctrl_next;
    locked_next <= (phase_error_next == 'b0);
  end
end

assign locked = locked_next;

endmodule