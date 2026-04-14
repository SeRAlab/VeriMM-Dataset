module watchdog_timer (
  input clk,
  input reset,
  input [31:0] timer_duration,
  output reg timer_reset
);

reg [31:0] timer_count;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    timer_count <= 0;
    timer_reset <= 0;
  end else begin
    timer_count <= timer_count + 1;
    if (timer_count >= timer_duration) begin
      timer_count <= 0;
      timer_reset <= 1;
    end else begin
      timer_reset <= 0;
    end
  end
end

endmodule